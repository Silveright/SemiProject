	------------------정리본-----------------------
	drop sequence order_item_seq;
	drop table order_item purge;
	drop table order_info purge;
    drop sequence order_info_seq;
	최종 주문 정보 테이블

	--1) 주문 정보 테이블
   
   create sequence order_info_seq
   alter sequence order_info_seq nocache
   create table order_info(--하나의 주문정보를 담는 테이블
    order_code number primary key,
    id varchar2(20) references customer(id),
    payment_option varchar2(20),
    address1 varchar2(150) not null,
    address2 varchar2(150) not null,
    post varchar2(5) not null,
    receiver_name varchar2(15) not null,
    receiver_phone varchar2(13) not null,
    order_cost number not null,
    delivery_message varchar2(150),
    order_date date default sysdate
	);

	--2) 주문 상품 테이블 
	
    create sequence order_item_seq
    alter sequence order_item_seq nocache
    
    create table order_item(--한 주문에서 각 상품의 정보를 담는 테이블
    orderitem_code number primary key,
    order_code number,
    product_code number,
    product_count number not null,
    product_price number not null,
    orderstate varchar2(30) default '배송 전',--배송 취소/ 배송 완료
    FOREIGN KEY (order_code) REFERENCES order_info(order_code),
    FOREIGN KEY (product_code) REFERENCES product(product_code)
	);
	
	--1)첫번째 주문이 이루어지는 경우
	--주문이 이루어지면 order_info에 데이터 삽입이 이루어지고(주문코드, 아이디, 결제방식, 주소1, 주소2, 우편번호, 이름, 전화번호, 총액, 배송메세지, 주문일)
	insert into order_info values (order_info_seq.nextval,'id', '무통장 입금','서울아파트', '10동 10호', '11111', '홍길동','01012341234',50000,'문 앞에 놔주세요',sysdate)
	--동시에 주문한 상품의 정보가 order_item 테이블에 삽입되어져야 한다. (주문상품코드(orderitem_code), 주문코드, 상품코드(product_code)>주문 상품의 product 테이블에 있는 상품코드, 상품 금액, 배송 상태> 주문 직후니까 무조건 '배송 전') 
	insert into order_item values (order_item_seq.nextval, 1, 1, 2, 10000, '배송 전')--orderitem_code PK, order_code(order_info 테이블의 order_info_seq.nextval로 들어간 번호), 주문한 상품의 상품코드(product테이블의 상품코드),
	insert into order_item values (order_item_seq.nextval, 1, 3, 2, 10000, '배송 전')--orderitem_code PK, order_code(order_info 테이블의 order_info_seq.nextval로 들어간 번호), 주문한 상품의 상품코드(product테이블의 상품코드),
																					-- 상품의 가격(수량에 따라 달라져야 함), 주문 상태 (주문을 하면 배송 전이 들어가야 함) 
	--한 건의 주문이 발생할 때 마다 order_info와 order_item 두 테이블의 주문 코드는 같아야 한다.
	
	--2)두번째 주문이 이루어지는 경우
	insert into order_info values (order_info_seq.nextval,'id', '무통장 입금','서울아파트', '10동 10호', '11111', '홍길동','01012341234',50000,'문 앞에 놔주세요',sysdate)
	insert into order_item values (order_item_seq.nextval, 2, 2, 1, 10000, '배송 전')

	select*from order_item
--주문 페이지에서 담은 정보가 두 테이블로 insert 되어야 함

	select count(*)
   from product p, order_info o, order_item oit
   where p.product_code=oit.product_code
   and o.order_code=oit.order_code
   and o.id='id'
   and oit.orderstate='배송 취소';

	
	select o.id, o.order_date, p.product_image, p.product_name, oit.product_count, 
	oit.product_price, oit.orderstate, p.product_code
    from product p, order_info o, order_item oit
    where p.product_code=oit.product_code
    and o.order_code=oit.order_code
    and o.id='id'
    
    
    
    select * from order_info
    select * from order_item
    select * from product
    
    
    --배송전, 배송완료인 경우 주문내역 페이지에 페이징 처리
   select count(*)
   from product p, order_info o, order_item oit
   where p.product_code=oit.product_code
   and o.order_code=oit.order_code
   and o.id='id'
   and (1=2 or oit.orderstate='배송 전' or oit.orderstate='배송 완료');
	
   select * 
   from
		(select rownum rnum, j.* 
		from (select o.id, o.order_date, p.product_image, p.product_name, p.product_code, 
			  oit.product_count, oit.product_price, oit.orderitem_code, oit.orderstate 
		      from product p, order_info o, order_item oit 
			  where p.product_code=oit.product_code 
			  and o.order_code=oit.order_code 
			  and o.id=id
			  and (1=2 or oit.orderstate='배송 전' or oit.orderstate='배송 완료')
			  order by o.order_date desc) j 
		      where rownum<=10) 
		where rnum>=1 and rnum<=10

		
		
	--배송 취소인 경우 주문 취소내역에 페이징 처리
   select count(*)
   from product p, order_info o, order_item oit
   where p.product_code=oit.product_code
   and o.order_code=oit.order_code
   and o.id='id'
   and oit.orderstate='배송 취소';
	
