select count(*) FROM (
SELECT CONVERT(concat('address/api/v1/taxons/ -H "Authorization: Bearer token" -H "Content-Type: application/json" -X POST --data ''{',
'"code":"',_fs_transliterate_ru(name),'",',
'"parent":"',_fs_transliterate_ru(parent_name),'",',
'"translations":{',
    '"ru_RU":{"name":"',name,'","slug":"',case when parent_name='' then 'category' else concat(_fs_transliterate_ru(parent_name),'/',
	_fs_transliterate_ru(name)) end,'"',
	'}',
    '}',
'}''
') USING utf8) as command,lvl
FROM категории_соответствия 
union
select CONVERT(concat('address/api/v1/taxons/ -H "Authorization: Bearer token" -H "Content-Type: application/json" -X POST --data ''{',
'"code":"',_fs_transliterate_ru(type_name),'",',
'"parent":"category",',
'"translations":{',
    '"ru_RU":{"name":"',type_name,'","slug":"','category/',_fs_transliterate_ru(type_name),'"',
	'}',
    '}',
'}''
') USING utf8) as command , 5 as lvl
from show_tovar where vid_prodan=0 and 
(type_name not in( select name from категории_соответствия) and type_name not in( select parent_name from категории_соответствия))
) v
order by lvl