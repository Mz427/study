#通配符
%                匹配0個或多個任意字符
_                匹配一个任意字符
[abc]            匹配abc中的任意單個字符
[^abc] or [!abc] 匹配除abc外的任意單個字符

create table mz_test.Product 
(
	product_id char(4) not null,
	product_name varchar(100) not null,
	product_type varchar(32) not null,
	sale_price integer,
	purchase_price integer,
	regist_date date,
	primary key (product_id)
);

drop table mz_test.Product;
alter table mz_test.Product add [drop] column [column_name];
alter table mz_test.product rename to column_name;

SELECT '商品' AS string, product_id AS "商品编号", product_name AS "商品名称", purchase_price AS "进货单价"
FROM mz_test.Product
where sale_price =[<>][>=][<=][<][>] 1000;

/*
FROM --> (INNER)JOIN --> ON --> WHERE --> GROUP BY --> AVG(), SUM(),... --> 
HAVING --> SELECT --> DISTINCT --> ORDER BY --> LIMIT --> TOP
*/

select product_type, count(*) 
from mz_test.product p 
group by product_type 
having count(*) > 2

SELECT product_name, product_type, regist_date
FROM Product
WHERE product_type = '办公用品' AND ( regist_date = '2009-09-11' OR regist_date = '2009-09-20');

BEGIN TRANSACTION;

COMMIT;

create view ProductSum(product_type, cnt_product)
as 
select product_type, count(*)
from mz_test.product p2 
group by product_type ;

drop view ProductSum;

str1 || str2
length(str1)

select current_date; 
select current_time;
select current_timestamp; 

select current_timestamp, extract (day from current_timestamp); 

cast("str1" as integer)

select product,
	case
		when condition then ''
		when condition then ''
	else ''
	end as 'name'
from tablename

/*集合运算*/
union
intersect
except

/*窗口函数*/
select product_name, product_type, sale_price, rank() over (partition by product_type order by sale_price) ranking
from product

/*grouping运算符*/
rollup
cube
grouping sets

/******************************************
