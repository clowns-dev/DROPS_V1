
# DROPS_V1 
### Monitoreo de Sueros Intravenosos en Tiempo Real

## Descripción del Proyecto 
**DROPS_V1** es una aplicación Flutter diseñada para monitorear en tiempo real el estado y flujo de sueros intravenosos en entornos médicos. Esta solución está enfocada en mejorar la eficiencia del personal médico, reducir riesgos asociados con errores en el suministro de sueros y optimizar la atención al paciente.

El sistema utiliza sensores integrados que envían datos a través del protocolo MQTT, lo que permite una comunicación rápida y eficiente entre los dispositivos y la aplicación. La información del nivel, velocidad de flujo y tiempo restante del suero intravenoso se presenta de forma clara en la interfaz de usuario.

## Características Principales 
- **Monitoreo en Tiempo Real:** Visualización constante de los niveles y flujo de sueros intravenosos mediante comunicación MQTT. 
- **Alertas Inteligentes:** Notificaciones automáticas cuando el nivel del suero es crítico o el flujo se detiene. 
- **Interfaz Intuitiva:** Diseño centrado en la experiencia del usuario para facilitar la toma de decisiones médicas. 
- **Conexión Segura y Eficiente:** Uso de MQTT para garantizar una comunicación ligera y rápida entre los sensores y la aplicación. 
- **Compatibilidad Multi-Plataforma:** Implementada en Flutter para dispositivos Android e iOS. 
## Tecnologías Utilizadas 
- **Flutter:** Framework para el desarrollo de aplicaciones móviles. 
- **Dart:** Lenguaje de programación principal. 
- **MQTT (Message Queuing Telemetry Transport):** Protocolo ligero para la comunicación de datos en tiempo real entre dispositivos IoT. 
- **Mosquitto Broker:** Servidor MQTT para gestionar la comunicación. 
## Instalación y Configuración 
### Requisitos Previos 
-  Tener Flutter instalado en tu sistema. Consulta la [documentación oficial](https://docs.flutter.dev/get-started/install?_gl=1*82ulup*_gcl_aw*R0NMLjE3MzI0NjM2ODAuQ2owS0NRaUF1b3U2QmhEaEFSSXNBSWZncm40S2JqUmZta1FKSy1na2IzbnRNWVFIMVpUZm1hU1VYNC1BU3cybkpsb0VOZWdrTy05UzFqY2FBcGxDRUFMd193Y0I.*_gcl_dc*R0NMLjE3MzI0NjM2ODAuQ2owS0NRaUF1b3U2QmhEaEFSSXNBSWZncm40S2JqUmZta1FKSy1na2IzbnRNWVFIMVpUZm1hU1VYNC1BU3cybkpsb0VOZWdrTy05UzFqY2FBcGxDRUFMd193Y0I.*_up*MQ..*_gs*MQ..*_ga*MTM0NjYxNTQ3NS4xNzIzMzExNzY0*_ga_04YGWK0175*MTczMjQ2MzY2Ny42LjEuMTczMjQ2MzY4MC4wLjAuMA..&gclid=Cj0KCQiAuou6BhDhARIsAIfgrn4KbjRfmkQJK-gkb3ntMYQH1ZTfmaSUX4-ASw2nJloENegkO-9S1jcaAplCEALw_wcB&gclsrc=aw.ds) para instrucciones. 
- Un dispositivo físico o emulador para probar la aplicación. 
- Sensores compatibles con MQTT configurados para monitorear sueros intravenosos. 
- Un broker MQTT (por ejemplo, Mosquitto) configurado y en funcionamiento. 
## Pasos para Instalar

- Clona este repositorio: 
```bash
  git clone https://github.com/tu-usuario/drops_v1.git
```


- Accede al directorio del proyecto: 
```bash
cd drops_v1
```
- Instala las dependencias del proyecto: 
```bash
flutter pub get 
```
## Uso de la Aplicación 
- Asegúrate de que los sensores MQTT estén conectados y enviando datos al broker. 
- Inicia la aplicación y verifica la conexión con el broker MQTT. 
- Monitorea los niveles y flujo del suero intravenoso en tiempo real desde la aplicación. - Recibe notificaciones cuando el nivel del suero sea crítico o haya anomalías en el flujo.
