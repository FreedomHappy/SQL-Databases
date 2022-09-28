-- ref: https://blog.csdn.net/qq_25112523/article/details/85252742
1.ROUND(X,D)函数  X指要处理的数，D是指保留几位小数     --会进行四舍五入法

select ROUND(123456.6789,2);
结果：123456.68

select ROUND(123456.6123,2);
结果：123456.61



2.TRUNCATE(X,D)函数   X指要处理的数，D是指保留几位小数       --不进行四舍五入

select TRUNCATE(123456.6789,2);
结果:123456.67



3.CONVERT(expr,type)转型函数   expr指要处理的数，type是指要转型的类型	  --会进行四舍五入法

select convert(123456.6789, DECIMAL(10,2));
结果：123456.68      --会把值转换成Decimal类型



4.CEILING(X)函数 	  --直接取整，个位+1

select CEILING(123456.6789);
结果：123457



5.FLOOR(X)函数  	  --直接取整

select FLOOR(123456.6789);
结果：123456