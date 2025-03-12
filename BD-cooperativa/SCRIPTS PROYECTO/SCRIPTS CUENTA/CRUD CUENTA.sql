--INSERTAR LA CUENTA DEL EMPLEADO AUTOMATICAMENTE EN LA BASE DE DAOS :P

CREATE TRIGGER TR_CREAR_CUENTAS_AFILIADO FOR AFILIADO
ACTIVE AFTER INSERT POSITION 0
AS
DECLARE VARIABLE v_codigo_afiliado VARCHAR(30);
DECLARE VARIABLE v_nombre_creador VARCHAR(30);
BEGIN
	
    v_codigo_afiliado = NEW.CODIGO;
    v_nombre_creador = NEW.USUARIO_CREADOR;


    INSERT INTO CUENTA (NUMERO_CUENTA, TIPO_CUENTA, INGRESADO_MES, SALDO, FECHA_APERTURA, FECHA_CREACION,  USUARIO_CREADOR, AFILIADO_CODIGO)
    VALUES (:v_codigo_afiliado || '-CAP', 'CAP', 0, 0.00, CURRENT_DATE, CURRENT_DATE, :v_nombre_creador, :v_codigo_afiliado);


    INSERT INTO CUENTA (NUMERO_CUENTA, TIPO_CUENTA, INGRESADO_MES, SALDO, FECHA_APERTURA, FECHA_CREACION,  USUARIO_CREADOR, AFILIADO_CODIGO)
    VALUES (:v_codigo_afiliado || '-CAR', 'CAR', 0, 0.00, CURRENT_DATE, CURRENT_DATE, :v_nombre_creador, :v_codigo_afiliado);
END;

CREATE TRIGGER TR_CUENTA_NUMERO FOR CUENTA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
    IF (NEW.TIPO_CUENTA = 'CAP') THEN
        NEW.NUMERO_CUENTA = NEW.AFILIADO_CODIGO || '-CAP';
    ELSE IF (NEW.TIPO_CUENTA = 'CAR') THEN
        NEW.NUMERO_CUENTA = NEW.AFILIADO_CODIGO || '-CAR';
END;


CREATE PROCEDURE LEER_CUENTAS_CAP
RETURNS (
 	NUMERO_CUENTA VARCHAR(30),
    TIPO_CUENTA CHAR(3),
    INGRESADO_MES INTEGER,  
    SALDO DECIMAL(18, 2),   
    FECHA_APERTURA DATE,
    FECHA_CREACION DATE,
    FECHA_ULTIMA_MODIFICACION DATE,
    USUARIO_CREADOR VARCHAR(30),
    ULTIMO_EDITOR VARCHAR(30),
    AFILIADO_CODIGO VARCHAR(30),
)AS
BEGIN
    FOR SELECT NUMERO_CUENTA,TIPO_CUENTA,INGRESADO_MES,SALDO,FECHA_APERTURA,FECHA_CREACION,FECHA_ULTIMA_MODIFICACION,
    FECHA_ULTIMA_MODIFICACION,USUARIO_CREADOR,ULTIMO_EDITOR,AFILIADO_CODIGO
        FROM CUENTA
        WHERE TIPO_CUENTA = 'CAP'
        INTO :NUMERO_CUENTA, :TIPO_CUENTA, :INGRESADO_MES, :SALDO, :SALDO,
             :FECHA_CREACION, :FECHA_ULTIMA_MODIFICACION, :FECHA_ULTIMA_MODIFICACION, :USUARIO_CREADOR, 
             :ULTIMO_EDITOR, :AFILIADO_CODIGO
    DO
        SUSPEND;
END;


CREATE PROCEDURE LEER_CUENTAS_CAR
RETURNS (
 	NUMERO_CUENTA VARCHAR(30),
    TIPO_CUENTA CHAR(3),
    INGRESADO_MES INTEGER,  
    SALDO DECIMAL(18, 2),   
    FECHA_APERTURA DATE,
    FECHA_CREACION DATE,
    FECHA_ULTIMA_MODIFICACION DATE,
    USUARIO_CREADOR VARCHAR(30),
    ULTIMO_EDITOR VARCHAR(30),
    AFILIADO_CODIGO VARCHAR(30),
)AS
BEGIN
    FOR SELECT NUMERO_CUENTA,TIPO_CUENTA,INGRESADO_MES,SALDO,FECHA_APERTURA,FECHA_CREACION,FECHA_ULTIMA_MODIFICACION,
    FECHA_ULTIMA_MODIFICACION,USUARIO_CREADOR,ULTIMO_EDITOR,AFILIADO_CODIGO
        FROM CUENTA
        WHERE TIPO_CUENTA = 'CAR'
        INTO :NUMERO_CUENTA, :TIPO_CUENTA, :INGRESADO_MES, :SALDO, :SALDO,
             :FECHA_CREACION, :FECHA_ULTIMA_MODIFICACION, :FECHA_ULTIMA_MODIFICACION, :USUARIO_CREADOR, 
             :ULTIMO_EDITOR, :AFILIADO_CODIGO
    DO
        SUSPEND;
END;


CREATE TRIGGER TR_ELIMINAR_CUENTAS_AFILIADO FOR AFILIADO
ACTIVE AFTER DELETE POSITION 0
AS
BEGIN
    DELETE FROM CUENTA
    WHERE AFILIADO_CODIGO = OLD.CODIGO;
END;
