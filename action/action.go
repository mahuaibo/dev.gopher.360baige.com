package main
//
//import (
//	"flag"
//	"fmt"
//	"dev.gopher.360baige.com/utils/db"
//	"dev.gopher.360baige.com/utils/tool"
//	"html/template"
//	"io/ioutil"
//	"log"
//	"os"
//	"os/exec"
//	"path/filepath"
//	"strings"
//	"github.com/jmoiron/sqlx"
//)
//
//func genModelFile(db *sqlx.DB, render *template.Template, dbName, dbConnection, tableName string) {
//	tableSchema := &[]tool.TABLE_SCHEMA{}
//	err := db.Select(tableSchema,
//		"SELECT COLUMN_NAME, DATA_TYPE,COLUMN_KEY,COLUMN_COMMENT from COLUMNS where "+
//			"TABLE_NAME"+ "='"+ tableName+ "' and "+ "table_schema = '" + *dbNameEx+ dbName+ "'")
//
//	if err != nil {
//		fmt.Println(err)
//		return
//	}
//
//	fileName := *modelFolder + dbName + "/" + strings.ToLower(tableName) + ".go"
//
//	os.Remove(fileName)
//	f, err := os.Create(fileName)
//
//	if err != nil {
//		fmt.Println(err)
//	}
//	defer f.Close()
//
//	model := &tool.ModelInfo{
//		PackageName:  dbName,
//		BDName:       *dbNameEx + dbName,
//		DBConnection: dbConnection,
//		TableName:    tableName,
//		ModelName:    tableName,
//		TableSchema:  tableSchema}
//
//	if err := render.Execute(f, model); err != nil {
//		log.Fatal(err)
//	}
//	fmt.Println(fileName)
//	cmd := exec.Command("goimports", "-w", fileName)
//	//cmd := exec.Command("gofmt", "-w", fileName)
//	cmd.Run()
//}
//
//var tplFile = flag.String("tplFile", "./action.tpl", "the path of tpl file")
//var modelFolder = flag.String("modelFolder", "../../dev.action.360baige.com/actions/", "the path for folder of model files")
//
//var dbInstanceName = flag.String("dbInstanceName", "db.DB", "the name of db instance used in model files")
//var dbIP = flag.String("dbIP", "182.92.163.192", "the ip of db host")
//var dbPort = flag.Int("dbPort", 3306, "the port of db host")
//var dbNameEx = flag.String("dbNameEx", "db_", "the name of db ex")
//var dbName = flag.String("dbName", "company", "the name of db")
//var userName = flag.String("userName", "demo2015", "the user name of db")
//var pwd = flag.String("pwd", "baige.2016", "the password of db")
//
//func main() {
//
//	flag.Parse()
//
//	logDir, _ := filepath.Abs(*modelFolder)
//	if _, err := os.Stat(logDir); err != nil {
//		os.Mkdir(logDir, os.ModePerm)
//	}
//
//	data, err := ioutil.ReadFile(*tplFile)
//	if nil != err {
//		fmt.Println("read tplFile err:", err)
//		return
//	}
//
//	render := template.Must(template.New("model").
//		Funcs(template.FuncMap{
//		"FirstCharUpper":       tool.FirstCharUpper,
//		"TypeConvert":          tool.TypeConvert,
//		"Tags":                 tool.Tags,
//		"ExportColumn":         tool.ExportColumn,
//		"Join":                 tool.Join,
//		"MakeQuestionMarkList": tool.MakeQuestionMarkList,
//		"ColumnAndType":        tool.ColumnAndType,
//		"ColumnWithPostfix":    tool.ColumnWithPostfix,
//	}).
//		Parse(string(data)))
//
//	var tablaNames []string
//	sysDB := db.GetDB(*dbIP, *dbPort, "information_schema", *userName, *pwd)
//	err = sysDB.Select(&tablaNames,
//		"SELECT table_name from tables where table_schema = '" + *dbNameEx + *dbName+"'")
//	if err != nil {
//		fmt.Println(err)
//	}
//
//	for _, table := range tablaNames {
//		genModelFile(sysDB, render, *dbName, *dbInstanceName, table)
//	}
//
//}
