CREATE TABLE log.log_ddl (

  id_ddl serial primary key,

  operacao text,
  
  usuario text default current_user,

  object_name text,
  
  query text default current_query(),

  data timestamptz DEFAULT timezone('America/Sao_Paulo', CURRENT_TIMESTAMP)

);

create unique index ix_tbl_log_ddl on log.log_ddl(id_ddl, operacao, usuario, object_name, query, data)

REVOKE DELETE, UPDATE ON LOG.log FROM PUBLIC
REVOKE DELETE, UPDATE ON LOG.log_DDL FROM PUBLIC