create database `QLBH_QTuan`;
use `QLBH_QTuan`;
create table Customer(
cID int primary key,
cName varchar(25),
cAge  tinyint
);
create table `Order`(
oID int primary key,
cID int,
oDate datetime,
oTotaPrice int,
foreign key (cID) references Customer(cID)
);
create table Product(
pID int primary key,
pName varchar(25),
pPrice int
);
create table OrderDetail(
oID int,
pID int,
odQTY int,
foreign key(oID) references `Order`(oID),
foreign key(pID) references `Product`(pID)
);
insert into Customer values
(1,"Minh Quan",10),
(2,"Ngoc Oanh",20),
(3,"Hong Ha",50);
insert into `Order`(oID,cID,oDate) values
(1,1,"2006/3/21"), 
(2,2,"2006/3/23"), 
(3,1,"2006/3/16");
insert into Product values
(1,"May Giat",3),
(2,"Tu Lanh",5),
(3,"Dieu Hoa",7),
(4,"Quat",1),
(5,"Bep Dien",2);
insert into OrderDetail values
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);
-- 2. hien thi thong tin 
select * from `Order` order by oDate desc;
-- 3 hien thi ten va gia Sp cao nhat
select pName, pPrice from Product where pPrice=(select max(pPrice)from Product);
-- 4 hien thi danh sach khach hang da mua hang va danh sach SP duoc mua boi khach hang do
select  c.cName ,p.pName from Customer c
 join `Order` o on o.cID=c.cID
join OrderDetail od on od.oID=o.oID
join Product p on od.pID=p.pID;
--  5.hien thi khach hang khong mua bat ky san pham nao
select cName from Customer where cName not in (
select  c.cName  from Customer c
 join `Order` o on o.cID=c.cID
join OrderDetail od on od.oID=o.oID
join Product p on od.pID=p.pID);
-- 6. hien thi chi tiet cua tung hoa don
select o.oID,o.oDate,od.odQTY,p.pName,p.pPrice from `Order` o 
join OrderDetail od on od.oID=o.oID
join Product p on od.pID=p.pID;
-- 7.
select d.oID,d.oDate, sum(d.Total) as Total from  
(select o.oID,o.oDate,(od.odQTY*p.pPrice) as Total from `Order` o 
join OrderDetail od on od.oID=o.oID
join Product p on od.pID=p.pID) as d  group by d.oID;
-- 8
create view Sales as 
select sum((od.odQTY*p.pPrice)) as Sales from `Order` o 
join OrderDetail od on od.oID=o.oID
join Product p on od.pID=p.pID;
-- 9 xoa cac rang buoc
alter table OrderDetail drop foreign key orderdetail_ibfk_1;
alter table OrderDetail drop foreign key orderdetail_ibfk_2;
alter table `Order` drop foreign key order_ibfk_1;
alter table Customer drop primary key;
alter table `Order` drop primary key;
alter table Product drop primary key;
-- 10 
delimiter //
create trigger cusUpdate 
after update on customer
for each row 
begin
update `order`
set cID=new.cID
where cId=old.cID;
end //
-- 11
delimiter //
create procedure delProduct(in ProName varchar(25))
begin 
delete from OrderDetail od where (od.pID = (select pID from product where pName like(ProName)));
delete from Product where pName like(proName);
end//
call delProduct("Quat");
