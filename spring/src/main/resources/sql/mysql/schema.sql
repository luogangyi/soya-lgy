drop table if exists categories;
create table categories (
    id bigint auto_increment,
    str varchar (32) not null unique,
    by_keyword boolean not null default false,
    str_en varchar (32) not null unique,
    primary key (id)
) engine=InnoDB;

drop table if exists labels;
create table labels (
    id bigint auto_increment,
    str varchar (32) not null unique,
    category_id bigint not null,
    primary key (id)
) engine=InnoDB;

drop table if exists label_keywords;
create table label_keywords (
    id bigint auto_increment,
    str varchar (32) not null unique,
    label_id bigint not null,
    primary key (id)
) engine=InnoDB;