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

object personaje {
	var  position = game.at(14,2)
    var property salud = 300
	var cantVidas = 3
	var cantPociones = 3
	const cantArmasPermitidas = 3
	const cantPocionesPermitidas = 3
	const property bolsa = []
	var estaEnCombate = false
	var property armaActual = mano //porque empieza con bolsa vacía

	method position() {
		return position
	}

	method image() { 
		return "personaje" + self.imagenSegunEstado() + "-32Bits.png"
	}

	method imagenSegunEstado() {
		if(self.estaSinArma()) {
			return ""
		} else {
			return self.armaActual().imagenParaPersonaje()
		}
	}

	method estaSinArma() {
		return bolsa.size()==0
	}

	method cantVidas() {
		return cantVidas
	}

	method cantPociones() {
		return cantPociones
	}

	/// ARMA    
    method equiparArma(armaNueva){
		self.validarEquiparArma()
    	bolsa.add(armaNueva) // mete el arma en la bolsa (atrás)
        self.armaActual(bolsa.head()) // Su arma actual es la primera de la bolsa (si no tenía ninguna, será la nueva)
    }
    
	method validarEquiparArma() {
	  if(bolsa.size() >= cantArmasPermitidas){ // para no hardcodear el numero que queremos que sea el max y para que en el futuro se pueda cambiar
		self.error("Ya tengo " + cantArmasPermitidas +" armas!")
	  }
	}

    method armaActual(arma){
        armaActual = arma
    }

	//MOVIMIENTO

	method mover(direccion) {
		self.validarMover(direccion)
		position = direccion.siguiente(position)
		dungeon.accionEnemigos()
	}   

	method validarMover(posicion) {
		const siguiente = posicion.siguiente(self.position())
		dungeon.validarDentro(siguiente)
		self.validarMoverPelea()
	}

	method validarMoverPelea() {
		if (estaEnCombate) {
			self.error(null)
		}
	}

	//COMBATE/PELEA (y habilidades, ya sean ataque, curación, etc)
    var property enemigoCombatiendo = null //el enemigo con quien está en combate
	var esTurno = false //si es su turno en un combate

    method estaEnCombate(condicion){
        estaEnCombate = condicion
    }

    method atacarPre() {
        esTurno = true //esto da luz verde a que el usuario pueda ejecutar una habilidad (lo que no se puede hacer si no estás en combate)
    }

	method atacar() {
        self.validarCombate() // para que no le pegue a x enemigo cuando no esta peleando
		enemigoCombatiendo.recibirDanho(armaActual.danho()) 
		armaActual.realizarActualizacionDeArmas()
        esTurno = false //Indica que ya pasó turno. Sirve para que no pueda atacar al enemigo cuando no es su turno
		combate.cambiarTurnoA(enemigoCombatiendo)   //como ya terminó el turno del pj, se cambia el turno al enemigo
	}

	method actualizarArmaActual() { //esto se ejecuta solamente cuando se descarta el arma actual
		if(bolsa.size()>1) {
			armaActual = bolsa.get(1) //pone la 2da de la bolsa como el arma actual (la 1ra es la que se va a descartar)
		} else {
			armaActual = mano
		}
	}

    method validarCombate() {
        if(!estaEnCombate || !esTurno){
            self.error("No puedo ejecutar una habilidad ahora")
        }
    }

	method recibirDanho(cantidad) {
		salud -= cantidad
	}
	
	method morir() {
		self.perderVida() // pierde una vida
		self.validarVida() // valida si está muerto (no tiene más vidas)
		position = game.at(2,2) 
        salud = 300
	}

	method perderVida() { //se pierde una vida cuando la salud del pj llega a 0
	  cantVidas -= 1
	}

	method validarVida() {
  
	  if (cantVidas <= 0) {
		mapa.limpiar()
		gestorDeFondo.image("fondoFin.png")
		game.schedule(500, {game.stop()})
	  }
    
	}

	method agregarPocion() {
		self.validarAgregarPocion() // valida si ya tiene 3 en el inventario y no la agarra.
		cantPociones += 1 
	}

	method validarAgregarPocion() {
	  if(cantPociones>=cantPocionesPermitidas){
		self.error("Ya tengo " + cantPocionesPermitidas +" pociones!")
	  }
	}

	method curarse() {
		self.validarCombate() // para que no le pegue a x enemigo cuando no esta peleando
		self.validarPociones()
		self.aumentarSalud(150)
		cantPociones -= 1
		esTurno = false //Indica que ya pasó turno. Sirve para que no pueda atacar al enemigo cuando no es su turno
		combate.cambiarTurnoA(enemigoCombatiendo)   //como ya terminó el turno del pj, se cambia el turno al enemigo
	}
	
	method aumentarSalud(saludSumada) {
		salud += saludSumada
	}

	method validarPociones() {
		if(cantPociones<=0) {
			self.error("No se puede realizar una curación sin pociones de vida")
		}
	}

}


