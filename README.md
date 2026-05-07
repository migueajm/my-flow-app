# Gastos Personales

Aplicacion Flutter para gestionar ingresos, gastos, ahorros e inversiones con SQLite local.

## Arquitectura

Se usa MVVM ligero:

- `models/`: entidades de dominio.
- `database/`: configuracion SQLite y consultas.
- `providers/`: estado y reglas de negocio usadas por la UI.
- `screens/`: vistas principales.
- `widgets/`: componentes reutilizables.

El manejo de estado usa `Provider` porque es simple, estable y suficiente para una app local con formularios, reportes y datos derivados del mes seleccionado.

## Ejecutar

```bash
flutter pub get
flutter run
```

Si necesitas generar carpetas nativas faltantes en un entorno nuevo:

```bash
flutter create .
flutter pub get
flutter run
```

## Incluye

- SQLite con tablas `ingresos`, `gastos`, `categorias`, `ahorros_inversiones` y `movimientos`.
- Persistencia por mes y anio.
- Division automatica 80% gastos / 20% ahorros e inversiones.
- Dashboard mensual.
- Registro de gastos con categorias.
- Gestion de cuentas de ahorro/inversion y movimientos.
- Reportes diario, semanal, mensual, comparacion entre meses.
- Graficos de pastel, barras y lineas con `fl_chart`.
- Tema claro, oscuro o sistema.
- Idioma Espanol/Ingles segun el dispositivo, con selector manual.
- Pantalla de inicio de sesion maquetada y acceso como invitado.
- Swipe para editar o eliminar gastos y movimientos de ahorro/inversion.
