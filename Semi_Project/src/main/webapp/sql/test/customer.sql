create table customer(
	id					varchar2(20) primary key,
	password			varchar2(20),
	name				varchar2(15),
	jumin				varchar2(14),
	gender				char(1),
	post				varchar2(5),
	address				varchar2(150),
	tel					varchar2(8),
	email				varchar2(30),
	register_date		date default sysdate,
	grade				char(1),
	secondhand_code		number(5) --foreign key references secondhand_board(secondhand_code) on delete cascade
);

insert into customer values('id', 1234, '홍길동', '123456-1234567', 'm', 11111, '서울 종로구',  
	'12341234','qwerty@qwerty.com',sysdate,'a',1)

	select * from customer
	update customer set name='홍길동', password='1234', post='11112', address='서울 강남구', tel='12341234', email='qwerty@qwerty.com'
	where id ='id';