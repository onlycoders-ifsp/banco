create schema log;
CREATE TABLE log.log (
        id             serial,
        date           TIMESTAMPTZ DEFAULT timezone('America/Sao_Paulo', CURRENT_TIMESTAMP),
        schemaname     text,
        tablename      text,
        operation      text,
        who            text DEFAULT current_user,
        new_val        json,
        old_val        json,
		QUERY		   TEXT DEFAULT CURRENT_QUERY()
);

create unique index ix_tbl_log on log.log(id, date, schemaname, tablename, operation, who)