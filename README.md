📊 Descripción del proyecto

Objetivo principal: Analizar métricas operativas (volumen de llamadas, tiempo de espera, tasa de abandono, nivel de servicio, etc.) para descubrir patrones, tendencias y oportunidades de mejora.

Preguntas de negocio:

¿En qué días u horas se concentra la mayor carga de llamadas?

¿Cuál es la velocidad promedio de atención y cómo se relaciona con la satisfacción del cliente?

¿Qué variables explican las llamadas abandonadas?

¿Podemos predecir picos de demanda para dimensionar el personal?



📝 Resultados esperados

Dashboard con las principales KPIs (tiempo de atención, SLA, tasa de abandono).

Gráficos de estacionalidad diaria y semanal.

Modelos de predicción de volumen y dimensionamiento de agentes.



### 📈 Visualizaciones generadas

**1. Histograma de llamadas entrantes**

![Histograma de llamadas entrantes](images/01_hist_incoming_calls.png)

> Muestra la distribución de llamadas entrantes para entender la carga total del centro.

**2. Histograma de llamadas abandonadas**

![Histograma de llamadas abandonadas](images/02_hist_abandoned_calls.png)

> Evalúa la frecuencia de llamadas que no fueron atendidas por agentes.

**3. Diagrama de dispersión: llamadas entrantes vs tiempo de espera y abandono**

![Diagrama de dispersión llamadas entrantes vs tiempo de espera y abandono](images/03_scatter_incoming_waiting_abandoned.png)

> Relaciona la cantidad de llamadas con el tiempo de espera y cuántas se abandonan.

**4. Diagrama de dispersión: SLA vs ASA y abandono**

![Diagrama de dispersión SLA vs ASA y abandono](images/04_scatter_sla_asa_abandoned.png)

> Mide cómo el nivel de servicio se correlaciona con el tiempo promedio de atención y la tasa de abandono.

**5. Boxplot: tiempo de espera según volumen de llamadas**

![Boxplot tiempo de espera según volumen de llamadas](images/05_boxplot_waiting_incoming.png)

> Detecta valores atípicos y patrones en la relación entre espera y cantidad de llamadas.

**6. Histograma de nivel de servicio (SLA)**

![Histograma nivel de servicio SLA](images/06_hist_sla.png)

> Visualiza la distribución del SLA para ver cuán frecuente se cumplen los objetivos de servicio.

**7. Mapa de calor de correlaciones entre variables**

![Mapa de calor de correlaciones](images/07_heatmap_correlation.png)

> Muestra las correlaciones entre métricas clave como abandono, espera, nivel de servicio, etc.

**8. Regresión lineal: abandono vs llamadas entrantes**

![Regresión lineal abandono vs llamadas entrantes](images/08_linear_regression_abandoned_incoming.png)

> Explora si hay una relación lineal entre el volumen de llamadas y el abandono.

**9. Gráfico combinado: llamadas contestadas y SLA por día y agente**

![Gráfico combinado llamadas contestadas y SLA](images/answered_calls_sla_combinado.png)

> Este gráfico muestra cuántas llamadas contestó cada agente (barras) y su nivel de SLA (línea) durante la semana. Ayuda a comparar rendimiento y calidad al mismo tiempo.




🤝 Contribuir

¡Las contribuciones son bienvenidas! Si deseas mejorar el análisis o añadir nuevas métricas:

Haz un fork del proyecto.

Crea una rama (git checkout -b feature/mi‑feature).

Confirma cambios y abre un pull request.
.

📄 Licencia

Este repositorio se distribuye bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.

📧 Contacto

Autor: Luis Ramón Buruato

LinkedIn: https://www.linkedin.com/in/luis-ramon-buruato-1a949741/
