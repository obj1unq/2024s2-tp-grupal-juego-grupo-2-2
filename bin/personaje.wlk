import wollok.game.*
import posiciones.*
import extras.*
import paleta.*
import enemigos.*
import armas.*
import randomizer.*
import pelea.*
import mapa.*
import animaciones.*
import niveles.*
import estado.*

object personaje {
	var position = game.at(14,2)
    var property salud = 300
	var cantVidas = 3
	var cantPociones = 3
	const cantPocionesPermitidas = 3
	var fuerzaAcumulada = 5
	const cantArmasPermitidas = 3
	const property bolsa = []
	var property turnosAturdido = 0
	const property esEnemigo = false
	var estado = estatico

	method position() {
		return position
	}

	method cantVidas() {
		return cantVidas
	}

	method cantPociones() {
		return cantPociones
	}

	method fuerzaAcumulada() {
		return fuerzaAcumulada
	}

	method estaAturdido() {
		return turnosAturdido > 0
	}

	method sufrirAturdimiento() {
		turnosAturdido -= 1
	}

	method estado(_estado) {
		estado = _estado
	}

	//ANIMACIONES

	var property animacion = animacionEstatica
	var property frame = 0

	method image() { 
		return "personaje" + animacion.tipoPersonaje() + frame + "-32Bits.png"
	}

	method cambiarAnimacion() {
		animacion.cambiarAnimacion(self)
	}

	method maxFrameEstatica() {
		return 8
	}

	method maxFrameCombate() {
		return 4
	}

	method maxFrameMuerte() {
		return 5
	}

	/// ARMA    
    method equiparArma(armaNueva){
		self.validarEquiparArma() //valida que no tenga 3 armas (si tiene 3, no la equipa)
		game.sound("anadirCosa.mp3").play()
    	bolsa.add(armaNueva) // mete el arma en la bolsa (atrás)
    }
    
	method validarEquiparArma() {
	  if(bolsa.size() >= cantArmasPermitidas){ // para no hardcodear el numero que queremos que sea el max y para que en el futuro se pueda cambiar
		self.error("Ya tengo " + bolsa.size() +" armas!")
	  }
	}

	method armaNumero(pos) { //PRECOND: Debe haber pos+1 armas en la bolsa
		return bolsa.get(pos)
	}

	method cambiarArmaActual() {
		self.validarTenenciaArmas()
		const armaAMover = bolsa.head()
		bolsa.remove(armaAMover)
		bolsa.add(armaAMover)
	}

	method validarTenenciaArmas() {
		if(bolsa.size() <= 1) {
			self.error("No hay armas suficientes para hacer el cambio")
		}
	}

	method armaActual() {
		if (bolsa.size() > 0) {
			return bolsa.head()
		} else {
			return mano
		}
	}

	method descartarArmaActual() { //PRECOND: Debe haber al menos un arma en la bolsa
		bolsa.remove(bolsa.head())
	}

	//MOVIMIENTO

	method mover(direccion) {
		self.validarMover(direccion)
		position = direccion.siguiente(position)
		game.sound("paso.mp3").play()
		dungeon.accionEnemigos()
	}   

	method validarMover(posicion) {
		const siguiente = posicion.siguiente(self.position())
		dungeon.validarDentro(siguiente)
		dungeon.validarNoHayObjetoNoTraspasable(siguiente)
		self.validarMoverPelea()
	}

	method validarMoverPelea() {
		if (self.estaEnCombate()) {
			self.error("")
		}
	}

	//COMBATE / PELEA (y habilidades/movimientos, ya sean ataque común, curación con poción o habilidad especial)
    var property enemigoCombatiendo = null //el enemigo con quien está en combate
	var esTurno = false //si es su turno en un combate

    method estaEnCombate(){
        return combate.hayCombate()
    }

    method atacarPre() {
        esTurno = true //esto da luz verde a que el usuario pueda realizar un turno (lo que no se puede hacer si no estás en combate)
    }

	////////////ATAQUE COMÚN//////////////////////

	method hacerTurnoAtaqueComun() {
        self.validarHacerTurno() // para que no le pegue a x enemigo cuando no está peleando / no es su turno / ya se encuentra haciendo turno
		self.frame(0)
		self.estado(golpeando)
		self.animacion(animacionCombate) //cambia su tipo de animación a la correspondiente
		game.schedule(800, {self.terminarHacerTurno()}) //dentro de 0,8 seg para que se pueda ver la animación primero
	}

	method validarHacerTurno() {
        if(!self.estaEnCombate() || !esTurno || !estado.puedeHacerTurno()){
            self.error("No puedo ejecutar una habilidad ahora")
        }
    }

	method terminarHacerTurno() {
		estado.realizarAccionCorrespondiente() //si es golpeando, será realizarAtaqueComun(), si es haciendoHabilidad, será realizarHabilidadEspecial(), y si es curandose, será usarPocionSalud()
		self.frame(0)
		self.estado(estatico) //luego de mostrados los frames de la animación, se setea la default
		self.animacion(animacionEstatica)
		combate.cambiarTurnoA(enemigoCombatiendo) //ya terminado el turno del pj, se cambia el turno al enemigo, que ejecutará su movimiento (o morirá si se quedó sin vida)
	}

	method realizarAtaqueComun() {
		enemigoCombatiendo.recibirDanho(self.armaActual().danho()) 
		self.armaActual().sonidoDelArma()
		self.armaActual().realizarActualizacionDeArmas()
        esTurno = false //Indica que ya pasó turno. Sirve para que no pueda atacar al enemigo cuando no es su turno
		barraEstadoPeleas.image("barraPersonajeAtaqueComun.png")
		self.sumarFuerzaAcumulada()
	}

	method recibirDanho(cantidad) {
		if(cantidad < salud) { //solo se ejecuta si personaje NO se muere (porque, al morir, ya hace otro sonido distinto)
			game.sound("ouch1.mp3").play() 
		}
		salud = (salud - cantidad).max(0)
	}

	//////////////////////////////////////////////
	
	////////////USO DE POCIÓN SALUD///////////////

	method agregarPocion() {
		self.validarAgregarPocion() // valida si ya tiene 3 en el inventario (de ser así, no la agarra)
		game.sound("anadirCosa.mp3").play()
		cantPociones += 1 
	}

	method validarAgregarPocion() {
	  if(cantPociones>=cantPocionesPermitidas){
		self.error("Ya tengo " + cantPociones +" pociones!")
	  }
	}

	method hacerTurnoPocion() {
		self.validarHacerTurno() // para que no se cure en combate cuando no está peleando / no es su turno / ya se encuentra haciendo turno
		self.validarPociones()
		self.frame(0)
		self.estado(curandose)
		self.animacion(animacionCurar) 
		game.schedule(800, {self.terminarHacerTurno()}) //dentro de 0,8 seg para que se pueda ver la animación primero
	}

	method usarPocionSalud() {
		game.sound("pocionSalud.mp3").play()
		self.aumentarSalud(150)
		cantPociones -= 1
		esTurno = false //Indica que ya pasó turno. Sirve para que no pueda atacar al enemigo cuando no es su turno
		barraEstadoPeleas.image("barraPersonajePocionSalud.png")
		self.sumarFuerzaAcumulada()
	}
	
	method aumentarSalud(saludSumada) {
		salud += saludSumada
	}

	method validarPociones() {
		if(cantPociones<=0) {
			self.error("No me puedo curar sin pociones de vida")
		}
	}

	//////////////////////////////////////////////

	////////////FUERZA / HABILIDADES ESPECIALES///////////////

	method sumarFuerzaAcumulada() {
		fuerzaAcumulada = (fuerzaAcumulada + 1).min(5)
	}

	method gastarFuerzaAcumulada() {
		fuerzaAcumulada = 0
	}

	method hacerTurnoHabilidadEspecial() {
		self.validarHacerTurno() // para que no use hab especial cuando no está peleando / no es su turno / ya se encuentra haciendo turno
		self.validarFuerzaAcumulada()
		game.sound("habilidadEspecialPersonaje.mp3").play() //sonido que nos avisa de que se uso la habilidad especial.
		self.frame(0)
		self.estado(haciendoHabilidad)
		self.animacion(animacionCombate) 
		game.schedule(800, {self.terminarHacerTurno()}) //dentro de 0,8 seg para que se pueda ver la animación primero
	}

	method validarFuerzaAcumulada() {
		if(fuerzaAcumulada < 5) {
			self.error("No tengo la suficiente fuerza acumulada")
		}
	}

	method realizarHabilidadEspecial() {
		self.armaActual().ejecutarHabilidadEspecial()
		self.armaActual().realizarActualizacionDeArmas()
		self.armaActual().sonidoDelArmaEspecial()
        esTurno = false //Indica que ya pasó turno. Sirve para que no pueda atacar al enemigo cuando no es su turno
		barraEstadoPeleas.image("barraPersonajeHabilidadEspecial" + self.armaActual().imagenHabilidadEspecialParaBarra() + ".png")
	}

	//////////////////////////////////////////////////////////

	//MUERTE

	method morir() {
		self.perderVida() // pierde una vida
		game.sound("muertepj.mp3").play()
		self.revivirOFinalizarPartida() // revisa si personaje está muerto (no tiene más vidas) o no y actua en consecuencia
	}

	method perderVida() { //se pierde una vida cuando la salud de personaje llega a 0
	  cantVidas -= 1
	}

	method revivirOFinalizarPartida() {
  
	  if (cantVidas <= 0) { //caso finalizar partida
    	self.frame(0)
		self.estado(muriendo)
		self.animacion(animacionMuerte)
		game.schedule(1000, {self.terminarFinalizarPartida()})
	  } else { //caso revivir
		self.frame(0)
		self.estado(muriendo)
		self.animacion(animacionMuerte)
		game.schedule(1000, {self.terminarRevivir()})
	  }
    
	}

	method terminarRevivir() {
		position = game.at(14,2)
		combate.hayCombate(false)
		barraEstadoPeleas.desaparecerJuntoADemasBarras()
		self.frame(0)
		self.estado(estatico)
		self.animacion(animacionEstatica)
		self.salud(300)
	}

	method terminarFinalizarPartida() {
		dungeon.detenerMusicaAmbiente()
		game.sound("perdio2.wav").play()
		dungeon.limpiarTablero()
		gestorDeFondo.image("fondoFin1.png")
		game.schedule(250, {game.stop()}) //con schedule porque, si no, no llegan a ejecutarse efectivamente los métodos de sonido
	}

    //////////////////////////////////////////////////////////////

    //NIVEL

    var enemigosAsesinados = 0


    method sumarEnemigoAsesinado(){
        enemigosAsesinados = enemigosAsesinados + 1
    }

    method pasarNivel(){
        console.println("PJ entró a la puerta")
        self.volverAPosicionSpawneos()
        enemigosAsesinados = 0
        game.schedule(200, {dungeon.pasarNivel()})
    }

    method enemigosAsesinados(){
        return enemigosAsesinados
    }

    method volverAPosicionSpawneos() {
        position = game.at(14,2)
    }

}

