use old_shop2;

drop temporary table if exists temp;
create temporary table temp select '1111111111111' as variant_code,'11111111' as razmer,0 as kolvo;
ALTER TABLE temp MODIFY variant_code VARCHAR(25) CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE temp MODIFY razmer VARCHAR(25) CHARACTER SET utf8 COLLATE utf8_general_ci;

create temporary table temp2
select 0 as o;

drop function if exists temp_add;
delimiter $$
CREATE  function  temp_add( tovar_id integer, rrs varchar(16383), kv integer) returns integer
begin
    declare z text default '';
    declare rr text default '';
    declare n_items integer default 0;
    declare exist integer default 0;
    
    if rrs is null then    
	insert into temp value (tovar_id,'',kv);
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
		insert into temp value (z,rr,1);
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

insert into temp2 select temp_add(id,razmery,kolvo) as o from show_tovar where vid_prodan=0;
 select * from temp;
drop temporary table if exists temp2;
drop temporary table if exists temp;
drop function if exists temp_add;