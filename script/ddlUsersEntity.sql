CREATE SCHEMA abfln;

ALTER SESSION SET CURRENT_SCHEMA = abfln;

-- table exames 

CREATE TABLE abfln.exames (
	id_exame uuid DEFAULT uuid_generate_v4() NOT NULL,
	data_realizacao timestamp NOT NULL,
	hora_realizacao timestamp NOT NULL,
	laudo_medico varchar NOT NULL,
	tipo_exame varchar NOT NULL,
	imagem_exame varchar NOT NULL,
	laudo_aprovado bool NOT NULL,
	id_pedido uuid DEFAULT uuid_generate_v4() NOT NULL,
	CONSTRAINT "PK_1d6004564e0f45cf6a1a1f2d041" PRIMARY KEY (id_exame)
);
CREATE UNIQUE INDEX "UQ_7eccb2a314597cc4d97eef07acb" ON abfln.exames (id_pedido);
CREATE UNIQUE INDEX unique_id_exame ON abfln.exames (id_exame);


-- abfln.exames foreign keys

ALTER TABLE abfln.exames ADD CONSTRAINT fk_exame_pedido FOREIGN KEY (id_pedido) REFERENCES abfln.pedidos(id_pedido);



-- table medicos 

CREATE TABLE abfln.medicos (
	id_medico uuid DEFAULT uuid_generate_v4() NOT NULL,
	crm varchar NOT NULL,
	ativo bool DEFAULT true NOT NULL,
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	cpf varchar NOT NULL,
	CONSTRAINT "PK_4fdf7753e28921b205480234672" PRIMARY KEY (id_medico,id)
);
CREATE UNIQUE INDEX unique_id_medico ON abfln.medicos (id_medico);


-- abfln.medicos foreign keys

ALTER TABLE abfln.medicos ADD CONSTRAINT fk_id_usuario FOREIGN KEY (id) REFERENCES abfln.usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE;



-- table migrations 

CREATE TABLE abfln.migrations (
	id serial DEFAULT nextval('migrations_id_seq'::regclass) NOT NULL,
	"timestamp" int8 NOT NULL,
	"name" varchar NOT NULL,
	CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id)
);



-- table pacientes 

CREATE TABLE abfln.pacientes (
	id_paciente uuid DEFAULT uuid_generate_v4() NOT NULL,
	nome_paciente varchar NOT NULL,
	cpf varchar NOT NULL,
	sexo_paciente varchar NOT NULL,
	cor_paciente varchar NOT NULL,
	aguarda_realizacao bool,
	datanasc_paciente timestamp NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_105479d9a4f1bea015407b060f5" PRIMARY KEY (id_paciente)
);
CREATE UNIQUE INDEX "UQ_d6737b831d4e311678dfce056b6" ON abfln.pacientes (cpf);
CREATE UNIQUE INDEX unique_id_paciente ON abfln.pacientes (id_paciente);



-- table pedidos 

CREATE TABLE abfln.pedidos (
	id_pedido uuid DEFAULT uuid_generate_v4() NOT NULL,
	nome_exame varchar NOT NULL,
	id_paciente uuid DEFAULT uuid_generate_v4() NOT NULL,
	id_medico uuid DEFAULT uuid_generate_v4() NOT NULL,
	CONSTRAINT "PK_9a67e2a4917b3656d2d23fe8b5e" PRIMARY KEY (id_pedido)
);
CREATE UNIQUE INDEX "UQ_29088c9832e482c43ad72ebe328" ON abfln.pedidos (id_paciente);
CREATE UNIQUE INDEX "UQ_2f0a85728b04a2bc87589d1602d" ON abfln.pedidos (id_medico);
CREATE UNIQUE INDEX unique_id_pedido ON abfln.pedidos (id_pedido);


-- abfln.pedidos foreign keys

ALTER TABLE abfln.pedidos ADD CONSTRAINT fk_medico_pedido FOREIGN KEY (id_medico) REFERENCES abfln.medicos(id_medico,id);
ALTER TABLE abfln.pedidos ADD CONSTRAINT fk_pedido_paciente FOREIGN KEY (id_paciente) REFERENCES abfln.pacientes(id_paciente);



-- table professores 

CREATE TABLE abfln.professores (
	id_professor uuid DEFAULT uuid_generate_v4() NOT NULL,
	titulacao varchar NOT NULL,
	id_medico uuid DEFAULT uuid_generate_v4() NOT NULL,
	CONSTRAINT "PK_fae3dad2bb3dbf2ba7797e3c789" PRIMARY KEY (id_professor)
);
CREATE UNIQUE INDEX "UQ_b85aeac361d94c82b8c507edd97" ON abfln.professores (id_medico);


-- abfln.professores foreign keys

ALTER TABLE abfln.professores ADD CONSTRAINT fk_professor_medico FOREIGN KEY (id_professor) REFERENCES abfln.medicos(id_medico,id);



-- table recomendacoes 

CREATE TABLE abfln.recomendacoes (
	id_recomendacao uuid DEFAULT uuid_generate_v4() NOT NULL,
	recomendacao_escrita varchar NOT NULL,
	data_prevista timestamp NOT NULL,
	hipotese_diagnostico varchar NOT NULL,
	aguarda_realizacao bool NOT NULL,
	id_pedido uuid DEFAULT uuid_generate_v4() NOT NULL,
	id_medico uuid DEFAULT uuid_generate_v4() NOT NULL,
	CONSTRAINT "PK_1b7234117b5e587c9e4d3942789" PRIMARY KEY (id_recomendacao)
);
CREATE UNIQUE INDEX "UQ_2a3ebc8efdda69fd78b9dfeece3" ON abfln.recomendacoes (id_medico);
CREATE UNIQUE INDEX "UQ_640429c05db7611e52600f914e1" ON abfln.recomendacoes (id_pedido);
CREATE UNIQUE INDEX unique_id_recomendacao ON abfln.recomendacoes (id_recomendacao);


-- abfln.recomendacoes foreign keys

ALTER TABLE abfln.recomendacoes ADD CONSTRAINT fk_recomendacoes_pedido FOREIGN KEY (id_pedido) REFERENCES abfln.pedidos(id_pedido);



-- table residentes 

CREATE TABLE abfln.residentes (
	id_residente uuid DEFAULT uuid_generate_v4() NOT NULL,
	ano_residencia numeric(131089,0) NOT NULL,
	CONSTRAINT "PK_ed284bbd7c9497a394488f1996f" PRIMARY KEY (id_residente)
);


-- abfln.residentes foreign keys

ALTER TABLE abfln.residentes ADD CONSTRAINT fk_residente_medico FOREIGN KEY (id_residente) REFERENCES abfln.medicos(id_medico,id);



-- table usuarios 

CREATE TABLE abfln.usuarios (
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	nome_do_usuario varchar NOT NULL,
	email_usuario varchar NOT NULL,
	senha varchar NOT NULL,
	tipo varchar NOT NULL,
	cpf varchar NOT NULL,
	crm varchar,
	titulacao varchar,
	data_residencia varchar,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "PK_d7281c63c176e152e4c531594a8" PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "UQ_d6fafb07a27c140e10dec207c11" ON abfln.usuarios (email_usuario);
CREATE UNIQUE INDEX "UQ_ebebcaef8457dcff6e6d69f17b0" ON abfln.usuarios (cpf);