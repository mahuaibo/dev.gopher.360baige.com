{{$exportModelName := .ModelName | ExportColumn}}package controllers

import (
	"github.com/astaxie/beego"
	"dev.cloud.360baige.com/rpc/client"
	"time"
	. "dev.model.360baige.com/models/{{.PackageName}}"
	. "dev.model.360baige.com/models/response"
	. "dev.model.360baige.com/models/paginator"
    . "dev.model.360baige.com/models/batch"
)

type {{$exportModelName}}Controller struct {
	beego.Controller
}

// @Title 新增
// @Description 新增
// @Success 200 {"code":200,"messgae":"ok", "data":{ ... ... }}
// @Param   accessToken     query   string true       "访问令牌"
// @Failure 400 {"code":400,"message":"..."}
// @router /add [get]
func (c *{{$exportModelName}}Controller) Add() {
	timestamp := time.Now().UnixNano() / 1e6
	var (
		res   Response // http 返回体
		reply {{$exportModelName}}
	)
	args := &{{$exportModelName}}{
		CreateTime: timestamp,
		UpdateTime: timestamp,
	}
	err := client.Call(beego.AppConfig.String("EtcdURL"), "{{$exportModelName}}", "Add", args, &reply)
	if err != nil {
		res.Code = ResponseSystemErr
		res.Messgae = "新增失败"
		c.Data["json"] = res
		c.ServeJSON()
	} else {
        res.Code = ResponseNormal
        res.Messgae = "新增成功"
        res.Data = reply
        c.Data["json"] = res
        c.ServeJSON()
	}
}

// @Title 信息
// @Description 信息
// @Success 200 {"code":200,"messgae":"信息查询成功", "data":{ ... ... }}
// @Param   id     query   string true       "ID"
// @Param   accessToken     query   string true       "访问令牌"
// @Failure 400 {"code":400,"message":"..."}
// @router /detail [get]
func (c *{{$exportModelName}}Controller) Detail() {
	id, _ := c.GetInt64("id")
	res := Response{}
	var reply {{$exportModelName}}
	args := &{{$exportModelName}}{
		Id: id,
	}
	err := client.Call(beego.AppConfig.String("EtcdURL"), "{{$exportModelName}}", "FindById", args, &reply)

	if err != nil {
		res.Code = ResponseSystemErr
		res.Messgae = "信息查询失败"
		c.Data["json"] = res
		c.ServeJSON()
	} else {
		res.Code = ResponseNormal
		res.Messgae = "信息查询成功"
		res.Data = reply
		c.Data["json"] = res
		c.ServeJSON()
	}
}

// @Title 信息修改
// @Description 信息修改
// @Success 200 {"code":200,"messgae":"ok", "data":{ ... ... }}
// @Param   id     query   string true       "ID"
// @Param   accessToken     query   string true       "访问令牌"
// @Failure 400 {"code":400,"message":"..."}
// @router /modify [post]
func (c *{{$exportModelName}}Controller) Modify() {
	id, _ := c.GetInt64("id")

	var reply {{$exportModelName}}
	res := Response{}
	args := &{{$exportModelName}}{
		Id: id,
	}
	err := client.Call(beego.AppConfig.String("EtcdURL"), "{{$exportModelName}}", "FindById", args, &reply)

	if err != nil {
		res.Code = ResponseSystemErr
		res.Messgae = err.Error()
		c.Data["json"] = res
		c.ServeJSON()
	}
	timestamp := time.Now().UnixNano() / 1e6
	reply.Id = id

	reply.UpdateTime = timestamp

	err = client.Call(beego.AppConfig.String("EtcdURL"), "{{$exportModelName}}", "UpdateById", reply, nil)

	if err != nil {
		res.Code = ResponseSystemErr
		res.Messgae = "信息修改失败！"
		c.Data["json"] = res
		c.ServeJSON()
	} else {
        res.Code = ResponseNormal
        res.Messgae = "信息修改成功！"
        c.Data["json"] = res
        c.ServeJSON()
	}
}

// @Title 信息列表
// @Description 信息列表
// @Success 200 {"code":200,"messgae":"ok", "data":{ ... ... }}
// @Param   pageSize  current  sord filters
// @Param   accessToken     query   string true       "访问令牌"
// @Failure 400 {"code":400,"message":"..."}
// @router /list [post]
func (c *{{$exportModelName}}Controller) List() {
	var reply Paginator
	res := Response{}
	pageSize, _ := c.GetInt("pageSize")
	current, _ := c.GetInt("current")
	markID, _ := c.GetInt64("markid")
	direction, _ := c.GetInt("direction")
	filters := c.GetString("filters")
	args := &Paginator{
		PageSize:  pageSize,
		Current:   current,
		MarkID:    markID,
		Direction: direction,
		Filters:   filters,
	}
	err := client.Call(beego.AppConfig.String("EtcdURL"), "{{$exportModelName}}", "List", args, &reply)
	if err != nil {
		res.Code = ResponseSystemErr
		res.Messgae = "信息查询失败"
		c.Data["json"] = res
		c.ServeJSON()
	} else {
		res.Code = ResponseNormal
		res.Messgae = "信息查询成功"
		res.Data = reply
		c.Data["json"] = res
		c.ServeJSON()
	}
}

// @Title 信息列表
// @Description 信息列表
// @Success 200 {"code":200,"messgae":"ok", "data":{ ... ... }}
// @Param   pageSize  current  sord filters
// @Param   accessToken     query   string true       "访问令牌"
// @Failure 400 {"code":400,"message":"..."}
// @router /updateByIds [post]
func (c *{{$exportModelName}}Controller) UpdateByIds() {
	var reply BackNumm
	res := Response{}
	ids := c.GetString("ids")
	timestamp := time.Now().UnixNano() / 1e6
	status, _ := c.GetInt8("status")
	args := &BatchModify{
		Ids:        ids,
		UpdateTime: timestamp,
		Status:     status,
	}
	err := client.Call(beego.AppConfig.String("EtcdURL"), "{{$exportModelName}}", "UpdateByIds", args, &reply)
	if err != nil {
		res.Code = ResponseSystemErr
		res.Messgae = "操作失败"
		c.Data["json"] = res
		c.ServeJSON()
	} else {
		res.Code = ResponseNormal
		res.Messgae = "操作成功"
		res.Data = reply
		c.Data["json"] = res
		c.ServeJSON()
	}
}

// @Title 批量新增
// @Description 批量新增
// @Success 200 {"code":200,"messgae":"ok", "data":{ ... ... }}
// @Param   pageSize  current  sord filters
// @Param   accessToken     query   string true       "访问令牌"
// @Failure 400 {"code":400,"message":"..."}
// @router /addMultiple [post]
func (c *{{$exportModelName}}Controller) AddMultiple() {
	var reply BackNumm
	res := Response{}
	timestamp := time.Now().UnixNano() / 1e6
	var args []Account
	var i int64
	for i = 0; i < 10; i++ {
		itemArgs := Account{
			CreateTime: timestamp,
			UpdateTime: timestamp,
		}
		args = append(args, itemArgs)
	}
	err := client.Call(beego.AppConfig.String("EtcdURL"), "Account", "AddMultiple", args, &reply)
	if err != nil {
		res.Code = ResponseSystemErr
		res.Messgae = "操作失败"
		c.Data["json"] = res
		c.ServeJSON()
	} else {
		res.Code = ResponseNormal
		res.Messgae = "操作成功"
		res.Data = reply
		c.Data["json"] = res
		c.ServeJSON()
	}
}