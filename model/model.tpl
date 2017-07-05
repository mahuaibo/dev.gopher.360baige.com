{{$exportModelName := .ModelName | ExportColumn}}package {{.PackageName}}

type {{$exportModelName}} struct {
	{{range .TableSchema}} {{.COLUMN_NAME | ExportColumn}} {{.DATA_TYPE | TypeConvert}} {{.COLUMN_NAME | Tags}} // {{.COLUMN_COMMENT}}
	{{end}}
}
