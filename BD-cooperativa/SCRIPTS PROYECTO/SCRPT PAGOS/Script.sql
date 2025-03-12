CREATE PROCEDURE REGISTRAR_PAGO (
    PRESTAMO_NUMERO VARCHAR(30),
    FECHA DATE,
AS
DECLARE VARIABLE v_monto_pago DECIMAL(18,2);
DECLARE VARIABLE v_interes_pago DECIMAL(18,2);
DECLARE VARIABLE v_saldo DECIMAL(18,2);
DECLARE VARIABLE v_tasa_interes DECIMAL(5,2);
DECLARE VARIABLE v_periodos INTEGER;
DECLARE VARIABLE v_numero_pago VARCHAR(30);
DECLARE VARIABLE v_consecutivo_pago INTEGER;
BEGIN
    -- Obtener la información del préstamo
    SELECT SALDO, TASA_INTERES, PERIODOS
    FROM PRESTAMOS
    WHERE NUMERO_PRESTAMOS = :PRESTAMO_NUMERO
    INTO :v_saldo, :v_tasa_interes, :v_periodos;

    -- Validar que el préstamo tenga saldo pendiente
    IF (v_saldo <= 0) THEN
        EXCEPTION 'El préstamo ya ha sido pagado en su totalidad.';

    -- Determinar el número de pago consecutivo
    SELECT COALESCE(MAX(CAST(NUMERO_PAGO AS INTEGER)), 0) + 1
    FROM PAGOS
    WHERE NUMERO_PRESTAMOS = :PRESTAMO_NUMERO
    INTO :v_consecutivo_pago;

    -- Formatear el número de pago con ceros a la izquierda
    v_numero_pago = LPAD(CAST(v_consecutivo_pago AS VARCHAR(5)), 5, '0');

    -- Calcular el monto del pago mensual (PMT en Excel)
    v_monto_pago = (v_saldo * (v_tasa_interes / 100 / 12)) / (1 - POWER(1 + (v_tasa_interes / 100 / 12), -v_periodos));

    -- Calcular el interés pagado en este pago (IPMT en Excel)
    v_interes_pago = v_saldo * (v_tasa_interes / 100 / 12);

    -- Insertar el pago en la tabla de pagos
    INSERT INTO PAGOS (
        NUMERO_PRESTAMOS, NUMERO_PAGO, FECHA, MONTO, INTERESES_PAGADOS
    ) VALUES (
        :PRESTAMO_NUMERO, :v_numero_pago, :FECHA, :v_monto_pago, :v_interes_pago
    );

    -- Actualizar el saldo del préstamo
    UPDATE PRESTAMOS
    SET SALDO = SALDO - (:v_monto_pago - :v_interes_pago)
    WHERE NUMERO_PRESTAMOS = :PRESTAMO_NUMERO;
END;



CREATE PROCEDURE LEER_PAGOS (
    PRESTAMO_NUMERO VARCHAR(30))
RETURNS (
    NUMERO_PAGO VARCHAR(5),
    FECHA DATE,
    MONTO DECIMAL(18,2),
    INTERES_PAGADO DECIMAL(18,2),
    USUARIO_CREADOR VARCHAR(30))
AS
BEGIN
    FOR SELECT 
            NUMERO_PAGO, FECHA, MONTO, INTERES_PAGADO, USUARIO_CREADOR
        FROM PAGOS
        WHERE PRESTAMO_NUMERO = :PRESTAMO_NUMERO
        ORDER BY NUMERO_PAGO ASC
    INTO 
        :NUMERO_PAGO, 
        :FECHA, 
        :MONTO, 
        :INTERES_PAGADO, 
        :USUARIO_CREADOR
    DO
    BEGIN
        SUSPEND; 
    END
END;