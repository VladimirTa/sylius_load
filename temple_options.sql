drop temporary table if exists temp;

create temporary table temp select '' as variant_code,0 as product_id,0 as cena, '' as razmer,0 as kolvo,'' as articule;
ALTER TABLE temp MODIFY variant_code VARCHAR(25) CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE temp MODIFY razmer VARCHAR(25) CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE temp MODIFY articule VARCHAR(25) CHARACTER SET utf8 COLLATE utf8_general_ci;

drop temporary table if exists temp2;
create temporary table temp2
select 0 as o;

drop function if exists temp_add;
delimiter $$
CREATE  function  temp_add( tovar_id integer, rrs varchar(16383), kv integer,cena integer,articule varchar(20)) returns integer
begin
    declare z text default '';
    declare rr text default '';
    declare n_items integer default 0;
    declare exist integer default 0;
    
    if rrs is null then    
	insert into temp value (tovar_id,tovar_id,cena,'',kv,articule);
    else
    set n_items=get_count_items(rrs,',');		
        label1: LOOP
        set rr=get_item(rrs, ',', n_items);			
            set z=concat(tovar_id,case when rr ='' then '' else '-' end, rr );            
        
            select count(*) into exist from temp where variant_code=z and razmer=rr;    
        if exist > 0 then 
	    #	select kolvo into @kolvo from temp where variant_code=@z;    
	    update temp set kolvo=kolvo+1 where variant_code=z  and razmer=rr;
        else
	    insert into temp value (z,tovar_id,cena,rr,1,articule);
        end if;
    
        SET n_items = n_items - 1;
        IF n_items > 0 THEN
	ITERATE label1;
        END IF; 
        LEAVE label1;
    END LOOP label1;
    end if;
    
    return 0;
END$$
delimiter ;

insert into temp2 select temp_add(id,razmery,kolvo,cena,articule) as o from show_tovar where vid_prodan=0;
delete from temp where kolvo=0;
SET SESSION group_concat_max_len = 1000000;
 select group_concat(razmer) into @option_values 
 from (select distinct concat('{"code": "SIZE_',razmer,'", "translations": {"ru_RU": { "value": "',razmer,'"} } }') as razmer from temp) t;
 
 select concat('{"code": "size","translations": {"ru_RU":{"name":"размер"}}, "values": [',@option_values,'] }') as opt from dual;
drop temporary table if exists temp2;
drop temporary table if exists temp;
drop function if exists temp_add;