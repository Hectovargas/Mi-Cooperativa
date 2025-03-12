CREATE PROCEDURE CREAR_ABONO (
    NUMERO_CUENTA VARCHAR(30),
    FECHA DATE,
    MONTO DECIMAL(18, 2),
    COMENTARIO VARCHAR(50))
RETURNS (NUEVO_SALDO DECIMAL(18, 2))
AS
DECLARE VARIABLE v_numero_transaccion VARCHAR(30);
DECLARE VARIABLE v_ultimo_numero INT;
DECLARE VARIABLE v_cuenta_existe INT;
BEGIN
    --verifico sila cuenta existe usando un count, si es 0 es falso si es > 1 es verdadero
    SELECT COUNT(*)
    FROM CUENTA
    WHERE NUMERO_CUENTA = :NUMERO_CUENTA
    INTO :v_cuenta_existe;

    IF (v_cuenta_existe = 0) THEN
    BEGIN
        EXCEPTION EX_CUENTA_NO_EXISTE 'La cuenta especificada no existe.';
    END

    -- Validar que el monto sea positivo
    IF (:MONTO <= 0) THEN
    BEGIN
        EXCEPTION EX_MONTO_INVALIDO 'El monto del abono debe ser mayor que cero.';
    END

    -- Obtener el último número de transacción para la cuenta
    SELECT MAX(CAST(SUBSTRING(NUMERO_TRANSACCION FROM CHAR_LENGTH(NUMERO_CUENTA) + 2) AS INT))
    FROM TRANSACCION
    WHERE NUMERO_CUENTA = :NUMERO_CUENTA
    INTO :v_ultimo_numero;

    -- Si no hay transacciones previas, empezar desde 1
    IF (v_ultimo_numero IS NULL) THEN
        v_ultimo_numero = 1;

    -- Generar el número de transacción
    v_numero_transaccion = :NUMERO_CUENTA || '-' || :v_ultimo_numero;

    IN AUTONOMOUS TRANSACTION DO
    BEGIN
	
        UPDATE CUENTA
        SET SALDO = SALDO + :MONTO
        WHERE NUMERO_CUENTA = :NUMERO_CUENTA;

        -- Insertar la transacción de abono
        INSERT INTO TRANSACCION (NUMERO_TRANSACCION, NUMERO_CUENTA, FECHA, MONTO, COMENTARIO, TIPO_TRANSACCION)
        VALUES (:v_numero_transaccion, :NUMERO_CUENTA, :FECHA, :MONTO, :COMENTARIO, 'C');
    END

    -- Obtener el nuevo saldo después de la actualización
    SELECT SALDO
    FROM CUENTA
    WHERE NUMERO_CUENTA = :NUMERO_CUENTA
    INTO :NUEVO_SALDO;

    SUSPEND; 
END