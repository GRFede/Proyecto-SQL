create table users (
  id bigint primary key generated always as identity,
  username text not null unique,
  email text not null unique,
  password_hash text not null
);

create table categories (
  id bigint primary key generated always as identity,
  name text not null unique
);

create table lists (
  id bigint primary key generated always as identity,
  user_id bigint not null references users (id),
  name text not null
);

create table tasks (
  id bigint primary key generated always as identity,
  list_id bigint not null references lists (id),
  category_id bigint references categories (id),
  name text not null,
  description text,
  due_date date,
  priority int,
  completed boolean default false
);