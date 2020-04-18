select concat('address/api/v1/products/ -H "Authorization: Bearer token" -H "Content-Type: application/json" -X POST --data ''',
'{"code": "',_fs_transliterate_ru(articule),'",',
'"mainTaxon": "',case when type_name is not null and type_name <> '' then _fs_transliterate_ru(type_name) else 'category' end,'", ',
'"productTaxons": "', _fs_transliterate_ru(concat(case when категория_путь(type_name,'')<>type_name then '' else 'category,' end,категория_путь(type_name,''))),'", ',
'"channels": [ "default" ],',
'"options": [ "size" ],',
'"attributes": [  { "attribute": "sex", "localeCode": "ru_RU", "value": "любой" }',
    case when pol is not null then  concat(',{ "attribute": "sex", "localeCode": "ru_RU", "value": "', pol,'" }') else '' end, ' ],',
'"translations": {"ru_RU": {"name": "',type_name,':',_fs_transliterate_ru(articule),'",',
'"slug": "',_fs_transliterate_ru(articule),'"} },',
case when images2sylius(0,id) is not null then concat('"images": [ ',images2sylius(0,id),' ], ') else '' end,
'"enabled": true }''') as sylius_data -- ,  images2sylius(1,id) as images 
from show_tovar 
where vid_prodan=0;