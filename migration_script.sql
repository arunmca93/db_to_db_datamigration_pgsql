SELECT    
    string_agg(concat(a.column_name,' ',a.data_type),',') with_datatype,
    string_agg(concat(a.column_name),',') columnnames,
    concat('insert into ',a.table_name,' (',string_agg(concat(a.column_name),','),') SELECT blockgroups.* FROM dblink(''dbname=<DBNAME> port=<PORT> host=<HOST> user=<USERNAME> password=<PASSWORD>'',''SELECT ',string_agg(concat(a.column_name),','),' FROM public.',a.table_name,''') AS blockgroups (',string_agg(concat(a.column_name,' ',a.data_type),','),') where blockgroups.id not in (select id from ',a.table_name,')')
    insert_query
FROM
    information_schema.columns a
inner join 	
    (SELECT blockgroups.*
    FROM dblink('dbname=<DBNAME> port=<PORT> 
    host=<HOST> user=<USERNAME> password=<PASSWORD>',
    'SELECT column_name,data_type,table_name FROM information_schema.columns')
    AS blockgroups(column_names character varying,data_types character varying, table_name character varying)) b
on b.column_names=a.column_name
where a.table_name=b.table_name and a.table_name in ('<TABLE_NAME1>','<TABLE_NAME2>') 
group by a.table_name
