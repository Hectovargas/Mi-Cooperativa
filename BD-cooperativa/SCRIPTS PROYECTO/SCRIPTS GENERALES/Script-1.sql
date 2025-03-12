INSERT INTO AFILIADO (
    PRIMER_NOMBRE, 
    SEGUNDO_NOMBRE, 
    PRIMER_APELLIDO, 
    SEGUNDO_APELLIDO, 
    CALLE, 
    AVENIDA, 
    NUM_CASA, 
    CIUDAD, 
    DEPARTAMENTO, 
    REFERENCIA, 
    CORREO_PRIMARIO, 
    CORREO_SECUNDARIO, 
    FECHA_NACIMIENTO, 
    FECHA_INICIO, 
    USUARIO_CREADOR
)
VALUES (
    'Juan',                  -- PRIMER_NOMBRE
    'Carlos',                -- SEGUNDO_NOMBRE
    'Pérez',                 -- PRIMER_APELLIDO
    'Gómez',                 -- SEGUNDO_APELLIDO
    'Calle Principal',       -- CALLE
    'Avenida Central',       -- AVENIDA
    '123',                   -- NUM_CASA
    'Ciudad de México',      -- CIUDAD
    'CDMX',                  -- DEPARTAMENTO
    'Cerca del parque',      -- REFERENCIA
    'juan.perez@example.com',-- CORREO_PRIMARIO
    'juan.backup@example.com',-- CORREO_SECUNDARIO
    '1990-05-15',            -- FECHA_NACIMIENTO (formato YYYY-MM-DD)
    CURRENT_DATE,            -- FECHA_INICIO (fecha actual)
    'admin123'               -- USUARIO_CREADOR
);
INSERT INTO USUARIO (
    ID_USUARIO, 
    CONTRASENA, 
    AFILIADO_CODIGO, 
    ROL
)
VALUES (
    'juan.perez',            -- ID_USUARIO
    'password123',           -- CONTRASENA
    'AF-00001',              -- AFILIADO_CODIGO (debe coincidir con un CODIGO existente en AFILIADO)
    'ADMIN'               -- ROL
);