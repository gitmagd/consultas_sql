# consultas_sql
Consultas de la base de datos gestión de alojamientos turísticos
# 🏨 accommodations_tourism

Base de datos relacional para la gestión de alojamientos turísticos: propietarios, huéspedes, reservas, pagos y reseñas.

---

## ⚙️ Motor de base de datos

| Parámetro | Valor |
|---|---|
| Motor | **PostgreSQL** |
| Versión mínima requerida | 14+ |
| Versión del dump original | 18.3 (custom format v1.16) |
| Encoding | UTF-8 |
| Locale | `en_US.UTF-8` |
| Locale provider | `libc` |

---
## 🗂️ Esquema de la base de datos

El esquema contiene **13 tablas**, organizadas en tres dominios funcionales:

```
accommodations_tourism
│
├── Catálogos
│   ├── accommodation_types
│   ├── amenities
│   └── booking_statuses
│
├── Entidades principales
│   ├── owners
│   ├── locations
│   ├── accommodations
│   ├── rooms
│   ├── guests
│   └── staff_users
│
└── Transacciones
    ├── bookings
    ├── booking_guests
    ├── payments
    └── reviews
```

---
---

## 📁 Estructura del repositorio

```
accommodations_tourism/
├── accommodation_database_restore.sql   # Script completo de restauración
└── README.md                            # Este archivo
```

---

## 📝 Licencia

Este proyecto es de uso educativo y de práctica. Los datos de prueba no corresponden a personas o entidades reales.
