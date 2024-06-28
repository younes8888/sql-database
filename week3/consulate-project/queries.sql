-- These are the queries that I used to create my consulate database project
-- To the find result, check consulate relation model in consulate project file
create table citizen (
first_name varchar(255) not null,
last_name varchar(255) not null,
date_of_birth date not null,
primary key (first_name,last_name,date_of_birth)
);

create table consular_registration ( 
id integer auto_increment,
citizen_first_name varchar(255) not null,
citizen_last_name varchar(255) not null,
citizen_date_of_birth date not null,
registered  boolean not null,
primary key (id),
foreign key (citizen_first_name,citizen_last_name,citizen_date_of_birth) references citizen(first_name,last_name,date_of_birth) on delete restrict
);

create table civil_status ( 
id integer auto_increment,
consular_registration_id integer not null,
place_of_birth text not null, 
marital_status text not null,
children integer,
date_of_deceased date default null,
primary key (id),
foreign key (consular_registration_id) references consular_registration(id)
);


create table identity_card ( 
id integer auto_increment,
id_number integer unique not null,
date_of_issuance date not null,
date_of_expiry date not null,
place_of_issuance varchar(255) not null,
civil_status_id integer not null,
primary key(id),
foreign key(civil_status_id) references civil_status(id)
);

create table passport ( 
id integer auto_increment,
passport_number integer unique not null,
date_of_issuance date not null,
date_of_expiry date not null,
place_of_issuance varchar(255) not null,
primary key(id)
);

create table identity_card_passport( 
identity_card_id integer,
passport_id integer default '0',
foreign key(identity_card_id) references identity_card(id) on delete cascade,
foreign key(passport_id) references passport(id) on delete cascade,
primary key(identity_card_id,passport_id)
);

create table proxy( 
id integer auto_increment,
identity_card_id integer not null,
date_of_issuance date not null,
proxy_type text,
primary key (id),
foreign key(identity_card_id) references identity_card(id) on delete cascade
);

-- Here, I create a view table to see citizen who passed away from 2020 onwards

create view registration_civil_status as
select citizen_first_name, citizen_last_name, date_of_deceased
from consular_registration cr 
join civil_status cs on cs.consular_registration_id = cr.id
where date_of_deceased > 01/01/2020;

-- Here I place an index to speed up my search for registered citizen
create index idx_registered
on consular_registration(registered);

-- This is a query to select registered citizen from consular_registeration table
select * 
from consular_registration cr 
where registered = 'true';

