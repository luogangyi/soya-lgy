drop table _task;
drop table _user;

create table _task (
	id number(19,0),
	title varchar2(128) not null,
	description varchar2(255),
	user_id bigint not null,
    primary key (id)
);

create table _user (
	id number(19,0),
	login_name varchar2(64) not null unique,
	name varchar2(64) not null,
	password varchar2(255) not null,
	salt varchar2(64) not null,
	roles varchar2(255) not null,
	regiser_date date not null,
	primary key (id)
);


create sequence _seq_task start with 100 increment by 20;
create sequence _seq_user start with 100 increment by 20;