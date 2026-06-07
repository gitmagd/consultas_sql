-- Consulta 01 - (NSERT - Insertar propietario - Agregar un nuevo propietario)
-- Agrega un nuevo propietario a la tabla owners con todos sus campos principales.

INSERT INTO owners (
  first_name, last_name, company_name,
  email, phone, tax_id,
  address_line1, city, state, country, postal_code
)
VALUES (
  'Juan', 'Perez', 'Hostal Sur S.A.',
  'juan.perez@hostalsur.com', '+503 7789-1234', 'SV-20260001',
  'Av. Masferrer Norte 35', 'San Salvador', 'San Salvador',
  'El Salvador', '00101'
);

SELECT *
FROM owners
WHERE email = 'juan.perez@hostalsur.com';

-- Consulta 02	(INSERT - Insertar alojamiento	Crear alojamiento vinculado)
-- Crea un alojamiento de tipo Hotel vinculado al propietario recién insertado
-- (owner_id=21) y una ubicación existente.

INSERT INTO accommodations (
  owner_id, accommodation_type_id, location_id,
  name, description, max_guests,
  bedroom_count, bathroom_count,
  base_price_per_night, currency_code,
  check_in_time, check_out_time, is_active
)
VALUES (
  21, 1, 19,
  'Hotel Vista Volcán',
  'Hotel boutique con vista panorámica al volcán de San Salvador.',
  6, 3, 2,
  185.00, 'USD',
  '14:00', '11:00', TRUE
);

-- ver registro insertado
SELECT *
FROM accommodations
WHERE name = 'Hotel Vista Volcán';


-- Consulta 03 (INSERT - Huésped y reserva - Registrar huésped y reserva)
-- Inserta primero un huésped nuevo y luego crea su primera reserva 
-- vinculada al alojamiento 21.

INSERT INTO guests (
  first_name, last_name, email, phone,
  date_of_birth, nationality
)
VALUES (
  'Charlisse', 'Fuentes', 'charlisse.fuentes@example.com', '+503 7263-0010',
  '1990-06-15', 'El Salvador'
);

INSERT INTO bookings (
  guest_id, accommodation_id, booking_status_id,
  check_in_date, check_out_date,
  adult_count, child_count,
  subtotal_amount, tax_amount, discount_amount, total_amount,
  booking_reference
)
VALUES (
  101, 21, 1,
  '2026-08-10', '2026-08-15',
  2, 0,
  925.00, 111.00, 0.00, 1036.00,
  'BK-ELSV2026A'
);

-- ver los registros ingresado
SELECT
    g.guest_id, g.first_name, g.last_name,g.email,g.phone,
    g.date_of_birth, g.nationality, b.booking_id, b.booking_reference, b.accommodation_id,
    b.booking_status_id,
    b.check_in_date,
    b.check_out_date,
    b.adult_count,
    b.child_count,
    b.subtotal_amount,
    b.tax_amount,
    b.discount_amount,
    b.total_amount
FROM guests g
INNER JOIN bookings b
    ON g.guest_id = b.guest_id
ORDER BY b.booking_id DESC;

-- Consulta 4 (INSERT- Insertar pago - Registrar pago)
-- Registra el pago con tarjeta de crédito para la reserva 101.

INSERT INTO payments (
  booking_id, amount,
  payment_method, payment_status,
  transaction_reference
)
VALUES (
  101, 1036.00,
  'CreditCard', 'Completed',
  'TTT-ELSV-20260810-001'
);
 -- ver los pagos hechos por el cliente
 SELECT *
FROM payments
WHERE booking_id = 101;

--  CONSULTA 05 (SELECT - 	Alojamientos activos - Filtrar activos)
-- Lista todos los alojamientos activos con su tipo, precio y moneda.

SELECT
  a.accommodation_id,
  a.name,
  at2.type_name,
  a.base_price_per_night,
  a.currency_code,
  a.max_guests
FROM accommodations a
JOIN accommodation_types at2
  ON a.accommodation_type_id = at2.accommodation_type_id
WHERE a.is_active = TRUE
ORDER BY a.base_price_per_night DESC;

-- CONSULTA 06 (SELECT	- Huéspedes por país - 	Filtrar por nacionalidad)
-- Filtra los huéspedes cuya nacionalidad sea 'El Salvador' (o cualquier país indicado).

SELECT
  guest_id,
  first_name,
  last_name,
  email,
  phone,
  nationality
FROM guests
WHERE nationality = 'El Salvador'
ORDER BY last_name, first_name;

-- CONSULTA 07 (SELECT	- Reservas por fechas - Uso de BETWEEN)
-- Recupera todas las reservas cuyo check-in cae dentro de un rango usando BETWEEN.

SELECT
  b.booking_id,
  b.booking_reference,
  g.first_name || ' ' || g.last_name AS guest_name,
  a.name AS accommodation,
  b.check_in_date,
  b.check_out_date,
  b.total_amount
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
JOIN accommodations a ON b.accommodation_id = a.accommodation_id
WHERE b.check_in_date BETWEEN '2025-06-01' AND '2025-08-31'
ORDER BY b.check_in_date;

-- CONSULTA 08 (UPDATE	- Actualizar precio	- Modificar precio)
--  Modifica el precio base por noche de un alojamiento específico.

UPDATE accommodations
SET
  base_price_per_night = 215.00,
  currency_code = 'USD'
WHERE accommodation_id = 21;

-- Verificar el cambio
SELECT accommodation_id, name, base_price_per_night, currency_code
FROM accommodations
WHERE accommodation_id = 21;

-- CONSULTA 09 (UPDATE - Estado reserva - Actualizar estado)
-- Cambia el estado de una reserva de Confirmed (2) a CheckedIn (3).

UPDATE bookings
SET booking_status_id = 3
WHERE booking_id = 10
  AND booking_status_id = 2;

-- Verificar el cambio
SELECT
  b.booking_id,
  b.booking_reference,
  bs.status_name
FROM bookings b
JOIN booking_statuses bs
  ON b.booking_status_id = bs.booking_status_id
WHERE b.booking_id = 10;

-- CONSULTA 10 (DELETE - Eliminar reseña -DELETE WHERE)
-- Borra una reseña específica por su ID, con verificación previa.

-- Verificar antes de eliminar
SELECT review_id, booking_id, guest_id, rating, review_title
FROM reviews
WHERE review_id = 5;

DELETE FROM reviews
WHERE review_id = 5;

-- CONSULTA 11 (JOIN - Reservas + huésped - INNER JOIN)
-- INNER JOIN entre bookings y guests para obtener el detalle completo de cada reserva.
SELECT
  b.booking_id,
  b.booking_reference,
  g.first_name || ' ' || g.last_name AS guest_name,
  g.email,
  g.nationality,
  b.check_in_date,
  b.check_out_date,
  b.total_nights,
  b.total_amount,
  bs.status_name
FROM bookings b
INNER JOIN guests g
  ON b.guest_id = g.guest_id
INNER JOIN booking_statuses bs
  ON b.booking_status_id = bs.booking_status_id
ORDER BY b.check_in_date DESC;

-- CONSULTA 12(JOIN - Alojamiento completo - INNER JOIN múltiple)
-- INNER JOIN múltiple: alojamiento + propietario + tipo + ubicación + amenidades.
SELECT
  a.accommodation_id,
  a.name,
  at2.type_name,
  a.base_price_per_night,
  a.currency_code,
  o.first_name || ' ' || o.last_name AS owner_name,
  o.email AS owner_email,
  l.city,
  l.country,
  STRING_AGG(am.amenity_name, ', ') AS amenities
FROM accommodations a
INNER JOIN accommodation_types at2
  ON a.accommodation_type_id = at2.accommodation_type_id
INNER JOIN owners o
  ON a.owner_id = o.owner_id
INNER JOIN locations l
  ON a.location_id = l.location_id
LEFT JOIN accommodation_amenities aa
  ON a.accommodation_id = aa.accommodation_id
LEFT JOIN amenities am
  ON aa.amenity_id = am.amenity_id
GROUP BY
  a.accommodation_id, a.name, at2.type_name,
  a.base_price_per_night, a.currency_code,
  o.first_name, o.last_name, o.email,
  l.city, l.country
ORDER BY a.accommodation_id;

-- CONSULTA 13 ( JOIN - Pagos + reservas - JOIN combinado)
-- JOIN entre payments, bookings, guests y accommodations para ver el historial de pagos.
SELECT
  p.payment_id,
  b.booking_reference,
  g.first_name || ' ' || g.last_name AS guest_name,
  a.name AS accommodation,
  p.payment_date,
  p.amount,
  p.payment_method,
  p.payment_status
FROM payments p
INNER JOIN bookings b
  ON p.booking_id = b.booking_id
INNER JOIN guests g
  ON b.guest_id = g.guest_id
INNER JOIN accommodations a
  ON b.accommodation_id = a.accommodation_id
ORDER BY p.payment_date DESC;

-- CONSULTA 14 (LEFT JOIN- Sin reseñas -Incluye nulls)
-- LEFT JOIN para encontrar alojamientos que no tienen ninguna reseña registrada.
SELECT
  a.accommodation_id,
  a.name,
  at2.type_name,
  a.base_price_per_night
FROM accommodations a
LEFT JOIN reviews r
  ON a.accommodation_id = r.accommodation_id
INNER JOIN accommodation_types at2
  ON a.accommodation_type_id = at2.accommodation_type_id
WHERE r.review_id IS NULL
ORDER BY a.accommodation_id;

-- CONSULTA 15 (LEFT JOIN	Sin reservas	Filtrar null)












