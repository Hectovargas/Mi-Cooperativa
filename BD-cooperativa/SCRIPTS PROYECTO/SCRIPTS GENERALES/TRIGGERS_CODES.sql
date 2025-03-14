
--CREATE SEQUENCE SEQ_AFILIADO; 
--ALTER SEQUENCE SEQ_AFILIADO RESTART WITH 1;

--Trigger para el codigo Automatico
CREATE TRIGGER TR_AFILIADO_CODIGO FOR AFILIADO
ACTIVE BEFORE INSERT POSITION 0 
AS 
DECLARE VARIABLE v_codigo varchar(30);
BEGIN 
	
	 v_codigo = 'AF-' || LPAD(NEXT VALUE FOR SEQ_AFILIADO, 5, '0');

    NEW.CODIGO = v_codigo;
    
END;

--Trigger para la fecha automatica afiliado
CREATE TRIGGER TR_AFILIADO_FECHA_INICIAL FOR AFILIADO
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN 
	NEW.FECHA_INICIO = CURRENT_TIMESTAMP;
END



--Trigger para crear las cuenta despues de crear el afiliado
CREATE TRIGGER TR_CREAR_CUENTAS_AFILIADO FOR AFILIADO
ACTIVE AFTER INSERT POSITION 0
AS
DECLARE VARIABLE v_codigo_afiliado VARCHAR(30);
DECLARE VARIABLE v_nombre_creador VARCHAR(30);
BEGIN
	
    v_codigo_afiliado = NEW.CODIGO;
    v_nombre_creador = NEW.USUARIO_CREADOR;


    INSERT INTO CUENTA (NUMERO_CUENTA, TIPO_CUENTA, INGRESADO_MES, SALDO, FECHA_APERTURA, USUARIO_CREADOR, AFILIADO_CODIGO)
    VALUES (:v_codigo_afiliado || '-CAP', 'CAP', 0, 0.00, CURRENT_DATE, :v_nombre_creador, :v_codigo_afiliado);


    INSERT INTO CUENTA (NUMERO_CUENTA, TIPO_CUENTA, INGRESADO_MES, SALDO, FECHA_APERTURA, USUARIO_CREADOR, AFILIADO_CODIGO)
    VALUES (:v_codigo_afiliado || '-CAR', 'CAR', 0, 0.00, CURRENT_DATE, :v_nombre_creador, :v_codigo_afiliado);
END;



--CUENTA
CREATE TRIGGER TR_CUENTA_NUMERO FOR CUENTA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
    IF (NEW.TIPO_CUENTA = 'CAP') THEN
        NEW.NUMERO_CUENTA = NEW.AFILIADO_CODIGO || '-CAP';
    ELSE IF (NEW.TIPO_CUENTA = 'CAR') THEN
        NEW.NUMERO_CUENTA = NEW.AFILIADO_CODIGO || '-CAR';
END;

--Trigger para la fecha automatica CUENTA
CREATE TRIGGER TR_CUENTA_FECHA_INICIAL FOR CUENTA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN 
	NEW.FECHA_APERTURA = CURRENT_TIMESTAMP;
	NEW.FECHA_CREACION = CURRENT_TIMESTAMP;
END

--CREATE SEQUENCE SEQ_PRESTAMO; 
--ALTER SEQUENCE SEQ_PRESTAMO RESTART WITH 1;

CREATE TRIGGER TR_PRESTAMO_NUMERO FOR PRESTAMOS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE v_numero_prestamo VARCHAR(30);
BEGIN
    v_numero_prestamo = NEW.AFILIADO_CODIGO || '-PT' || LPAD(NEXT VALUE FOR SEQ_PRESTAMO, 5, '0');
    NEW.NUMERO_PRESTAMOS = v_numero_prestamo;
END;

CREATE TRIGGER ASIGNAR_TASA_INTERES FOR PRESTAMOS
BEFORE INSERT OR UPDATE
AS
BEGIN
    IF (NEW.TIPO_PRESTAMO = 'AUTOMATICO') THEN
        NEW.TASA_INTERES = 10.00;
    ELSE IF (NEW.TIPO_PRESTAMO = 'FIDUCIARIO') THEN
        NEW.TASA_INTERES = 15.00;
END;

--ABONO

CREATE TRIGGER TR_TRANSACCION_CODIGO FOR TRANSACCION
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE v_ultimo_numero INT;
BEGIN
   
    SELECT MAX(CAST(SUBSTRING(NUMERO_TRANSACCION FROM CHAR_LENGTH(NUMERO_CUENTA) + 2) AS INT))
    FROM TRANSACCION
    WHERE NUMERO_CUENTA = NEW.NUMERO_CUENTA
    INTO :v_ultimo_numero;

    
    IF (v_ultimo_numero IS NULL) THEN
        v_ultimo_numero = 1;

    
    NEW.NUMERO_TRANSACCION = NEW.NUMERO_CUENTA || '-' || v_ultimo_numero;
END;

--pago

CREATE TRIGGER TR_PAGO_NUMERO FOR PAGOS
ACTIVE BEFORE INSERT POSITION 0 AS DECLARE VARIABLE v_ultimo_pago INT;
BEGIN
    
    SELECT MAX(CAST(NUMERO_PAGO AS INT))
    FROM PAGOS
    WHERE NUMERO_PRESTAMOS = NEW.NUMERO_PRESTAMOS
    INTO :v_ultimo_pago;

    
    IF (v_ultimo_pago IS NULL) THEN
        v_ultimo_pago = 1;

    
    NEW.NUMERO_PAGO = LPAD(v_ultimo_pago, 5, '0');
END;


