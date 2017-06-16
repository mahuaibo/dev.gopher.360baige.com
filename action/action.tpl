{{$exportModelName := .ModelName | ExportColumn}}package {{.PackageName}}

import (
	_ "github.com/go-sql-driver/mysql"
	"github.com/astaxie/beego/orm"
	"dev.model.360baige.com/models/{{.PackageName}}"
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
