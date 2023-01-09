# Nadai SHARP

## ¿Qué es SHARP?

SHARP o **`(Secure Hardware-Assisted Remote Proofs)`** es una plataforma de verificación de programas desarrollada por StarkNet. Su objetivo es garantizar la seguridad y la verificabilidad de los contratos inteligentes escritos en Cairo, el lenguaje de programación de Starknet.

Cuando se envía un programa Cairo a SHARP, este utiliza un proceso denominado `"probabilidad mínima de desacuerdo"` para generar una prueba de la validez de su ejecución. Esto implica ejecutar el programa en un entorno de ejecución seguro y recopilar un conjunto de datos que demuestra que el programa se ha ejecutado de manera correcta y completa, siguiendo todas las reglas especificadas en el lenguaje Cairo. Una vez generada la prueba, SHARP la envía a la testnet de Ethereum Goerli, donde un contrato inteligente verificador la evalúa, si la prueba es válida, el contrato inteligente registra la ejecución del programa en la blockchain.

SHARP ofrece una interfaz de línea de comandos `(cairo-sharp)` y un API para facilitar el envío y la consulta de programas. Los usuarios pueden utilizar estas herramientas para enviar sus programas a SHARP y recibir actualizaciones sobre el progreso de la verificación. Una vez que un programa ha sido verificado y registrado en la blockchain, puede ser ejecutado de manera segura y confiable por cualquier persona que tenga acceso a la blockchain.

![Graph](/im%C3%A1genes/architecture.png)

SHARP es una plataforma valiosa para garantizar la seguridad y la verificabilidad de los contratos inteligentes escritos en Cairo. Su uso aumenta a medida que se desarrollen más aplicaciones basadas en el lenguaje. Sin embargo, es importante tener en cuenta que, en su forma actual, SHARP es un servicio centralizado que actúa como intermediario entre los programas Cairo y la blockchain. 

En Cairo 1.0 se está trabajando en la implementación de soluciones de gobernanza descentralizadas para mejorar la descentralización del proceso de verificación de programas.

Conocimientos o recursos necesarios, e información sobre SHARP:

* [Ajustes de Configuración de entorno](https://www.cairo-lang.org/docs/quickstart.html)
* También puede seguir David Barreto [`Setting Starknet Dev-environment Python`]((https://medium.com/starknet-edu/setting-up-a-starknet-dev-environment-with-python-e4c61c1e8da6))

* [Documentación oficial sobre Cairo-SHARP](https://www.cairo-lang.org/docs/sharp.html)
* [Presentación Basecamp Edition January 2023](https://github.com/starknet-edu/basecamp/tree/main/camp_1)
* [PDF del Basecamp Edition January 2023 LINK](https://docs.google.com/presentation/d/1rjV7nFGuXyIWghbKpIJmOVox8EVbEX974xCHzL4XU5o/edit)


## Pruebas con Sharp

Haremos el compile de un contrato que tenemos premarado como [sum.cairo](/src/sum.cairo) el cual le haremos una prueba inicial para ve que nos imprime el resultado correcto, pero primero veamos unas fotos de como SHARP funciona y el trabajo que nos resuevle.

![Graph](/im%C3%A1genes/donttrust.png)
![Graph](/im%C3%A1genes/trust.png)

* Sequencer: Calida, agrupa y ejecuta transacciones
* Prover: Crea una prueba que certifica que el nuevo estado global es el resultado de ejecutar todas las transacciones en un bloque
* Verifier: Contrato inteligente en L1 que verifica la prueba de validez enviada por el Prover
* Fact Registry: contrato inteligente que almacena las pruebas que se han verificado con éxito

Ahora que entedemos mejor SHARP, deberemos ajustar nuestra configuración de entorno, usaremos desde nuestra terminal:

```bash
python3.9 -m venv ~/cairo_venv
source ~/cairo_venv/bin/activate
```

![Graph](/im%C3%A1genes/env.png)


Luego si hemos clonado esta repo no nos hara falta crear el contrato, sino, debera de crear una carpeta `src` y otra `build` en el que le indicaremos con el siguiente comando en la terminal la salida del compile en `.json`.

```bash
cairo-compile src/sum.cairo --output build/sum.json
```

Si todo ha ido bien se debería crea un archivo `sum.json` en nuestra carpeta de `build`, con el que haremos la prueba para ver si nos imprime el resultado correcto, en la versión [sum.cairo](/src/sum.cairo) podemos ver una suma de 3 cantidades, las cuales deberian dar `131`, así que procedemos a los comandos:

```bash
cairo-run --program build/sum.json --print_output --layout=small
```

![Graph](/im%C3%A1genes/run.png)

Luego haremos el submit sharp, que nos ejecutará una serie de pasos hasta subir el programa o código, y nos dará un `Job key` y un `Fact`. Podemos consultar su estado para verificar que ha sido aceptada, ya que mientras esté en proceso no podremos verificar la vericidad de la prueba, esto suele llevar algunos minutos por parte del SHARP.

```bash
cairo-sharp submit --source src/sum.cairo
```

![Graph](/im%C3%A1genes/submit.png)


Que podremos verficar el estado con el `Job-key` hasta que veamos que cambió su estado usando desde el terminal:

```bash
cairo-sharp status 1e1ec39a-4ebe-48a8-9273-0b2aa1542c9a
```

![Graph](/im%C3%A1genes/progres.png)
![Graph](/im%C3%A1genes/ok.png)


## RCP de Alchemy 

En este paso creamos nuestro propio rcp para no tener que depender de llamadas de nadie, aunque podria usar cualqueir rcp,usaremos directamente de nuestro nodo así podemos verficar el estado de la prueba, para ello deberemos de crear una cuenta en [Alchemy](https://auth.alchemy.com/), después de hacer el registro podremos crear su propia App con ajustes de Goerli y copiar la dirección de rcp de su nodo que usaremos una vez haya sido aceptada la prueba, fíjese en la siguiente foto y recuerdo que todos estos datos sensibles al final sólo son en entornos de pruebas.

![Graph](/im%C3%A1genes/app.png)
![Graph](/im%C3%A1genes/api.png)
 
 Y una vez aceptada la prueba podremos verifcarla usando el siguiente comando.

```bash
cairo-sharp is_verified 0x908f30889da7846d2051b189322802dde73e55cb1d34eb4ae892fb4d04d71376 --node_url https://eth-goerli.g.alchemy.com/v2/zbIXJ9iA7vvwIJH9DagNh_4LSYhId9mW
```

![Graph](/im%C3%A1genes/verified.png)

Puede verificar el estado de su prueba ha sido correcta desde [aquí](https://goerli.etherscan.io/address/0xAB43bA48c9edF4C2C4bB01237348D1D7B28ef168#readProxyContract#F5), podra revisar que su prueba ha sido aceptada.

![Graph](/im%C3%A1genes/true.png)


## Comandos CLI

A continuación les adjunto usados para esta guía sin los valores.

* Compile
```bash
cairo-compile src/sum.cairo --output build/sum.json
```
* Run & print output
```bash
cairo-run --program build/sum.json --print_output --layout=small
```
* Debug memory
```bash
cairo-run --program build/sum.json --print_memory --relocate_prints
```
* Debug memory of unbound program
```bash
cairo-run --program build/sum.json --print_memory --relocate_prints --no_end --steps 16
```
* Compile, run and submit to sharp
```bash
cairo-sharp submit --source src/sum.cairo
```
* Sharp job status
```bash
cairo-sharp status <job-key>
```
* Proof validity status
```bash
cairo-sharp is_verified <fact> --node_url <eth-rpc-url>
```




