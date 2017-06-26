{{$exportModelName := .ModelName | ExportColumn}}package {{.PackageName}}

import (
	_ "github.com/go-sql-driver/mysql"
	"github.com/astaxie/beego/orm"
	"dev.model.360baige.com/models/{{.PackageName}}"
	"dev.model.360baige.com/models/paginator"
    "dev.model.360baige.com/models/batch"
)

type {{$exportModelName}}Action struct {
}

// 新增
func (*{{$exportModelName}}) Add(args *{{.PackageName}}.{{$exportModelName}}, reply *{{.PackageName}}.{{$exportModelName}}) error {
	o := orm.NewOrm()
	o.Using("{{.PackageName}}")
	id, err := o.Insert(args)
	if err == nil {
		{{range .TableSchema}}{{$column_name := .COLUMN_NAME | ExportColumn}}{{ if eq $column_name "Id" }}reply.{{$column_name}} = id{{ else }}reply.{{$column_name}} = args.{{$column_name}}{{ end }}
		{{end}}
	}
	return err
}

// 查询 by Id
func (*{{$exportModelName}}) FindById(args *{{.PackageName}}.{{$exportModelName}}, reply *{{.PackageName}}.{{$exportModelName}}) error {
	o := orm.NewOrm()
	o.Using("{{.PackageName}}")
	reply.Id = args.Id
	err := o.Read(reply)
	return err
}

// 更新 by Id
func (*{{$exportModelName}}) UpdateById(args *{{.PackageName}}.{{$exportModelName}}, reply *{{.PackageName}}.{{$exportModelName}}) error {
	o := orm.NewOrm()
	o.Using("{{.PackageName}}")
	num, err := o.Update(args)
	if err == nil {
		if num > 0 {
			reply.Id = args.Id
		}
	}
	return err
}

// 1. AddMultiple 增加多个
func (*{{$exportModelName}}) AddMultiple(args []*{{.PackageName}}.{{$exportModelName}}, reply *batch.BackNumm) error {
	o := orm.NewOrm()
	o.Using("{{.PackageName}}") //查询数据库
	num, err := o.InsertMulti(100, args)
	reply.Num = num
	return err
}

// 2.UpdateByIds 修改多个,默认更改状态为-1，只适合id,更改status,update_time
func (*{{$exportModelName}}) UpdateByIds(args *batch.BatchModify, reply *batch.BackNumm) error {
	o := orm.NewOrm()
	o.Using("{{.PackageName}}")            //查询数据库
	qs := o.QueryTable("{{.PackageName}}") //查询表名
	if (args.UpdateTime == 0) {
		args.UpdateTime = time.Now().UnixNano() / 1e6
	}
	if (args.Status == 0) {
		args.Status = -1
	}
	idsArg := strings.Split(args.Ids, ",")
	qs = qs.Filter("id__in", idsArg)
	num, err := qs.Update(orm.Params{
		"status":      args.Status,
		"update_time": args.UpdateTime,
	})
	reply.Num = num
	return err
}

// 3.查询List （按ID, 按页码）
func (*{{$exportModelName}}) List(args *paginator.Paginator, reply *paginator.Paginator) error {
	o := orm.NewOrm()
	o.Using("{{.PackageName}}")            //查询数据库
	qs := o.QueryTable("{{.PackageName}}") //查询表名
	qc := o.QueryTable("{{.PackageName}}") //查询表名
	filters := args.Filters
	// json str struct
	var items []paginator.PaginatorItem
	jsonErr := json.Unmarshal([]byte(filters), &items)
	if (jsonErr == nil) {
		for _, item := range items {
			if (item.O == "") {
				qs = qs.Filter(item.K, item.V)
				qc = qc.Filter(item.K, item.V)
			} else {
				qc = qc.Filter(item.K+"__"+item.O, item.V)
				qs = qs.Filter(item.K+"__"+item.O, item.V)
			}
		}
	}
	start := 0
	if ((args.Current - 1) > 0) {
		start = (args.Current - 1) * args.PageSize
	}
	if (args.MarkID != 0 && args.Direction != 0) {
		if (args.Direction == -1) {
			qc = qc.Filter("id__gt", args.MarkID)
			qs = qs.Filter("id__gt", args.MarkID)
		} else {
			qc = qc.Filter("id__lt", args.MarkID)
			qs = qs.Filter("id__lt", args.MarkID)
		}
	}
	reply.Total, _ = qc.Count()
	if (args.Sord != "") {
		qs = qs.OrderBy("-" + args.Sord)
	} else {
		qs = qs.OrderBy("-id")
	}
	qs = qs.Limit(args.PageSize, start)
	_, err := qs.Values(&reply.List)
	return err
}