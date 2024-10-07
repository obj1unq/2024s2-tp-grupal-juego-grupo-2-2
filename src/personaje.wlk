import wollok.game.*
import posiciones.*
import extras.*
import paleta.*
import enemigos.*
import armas.*
import randomizer.*
import pelea.*

object personaje {

	var  position = game.at(7,2);
    var property vida = 450
	const property bolsa = []
	var estaEnCombate = false
	var property armaActual = mano //en vez de bolsa.head() porque ahora empieza con bolsa vacía

	method position() {
		return position
	}

	method image() { //image() se calcula a cada frame al igual que position(), si no entendí mal
		return "personaje" + self.estado().imagenParaPersonaje() + "-32Bits.png"
	}

	method estado() {
		if(self.estaSinArma()) {
			return sinArma
		} else {
			return conArma
		}
	}

	method estaSinArma() {
		return bolsa.size()==0
	}

	/// ARMA    
    method equiparArma(armaNueva){
    	bolsa.add(armaNueva) // mete el arma en la bolsa (atrás)
        self.armaActual(bolsa.head()) // Su arma actual es la primera de la bolsa (si no tenía ninguna, será la nueva)
		game.removeVisual(armaNueva)
    }
    
    method armaActual(arma){
        armaActual = arma
    }

	//MOVIMIENTO

	method mover(direccion) {
		self.validarMover(direccion)
		position = direccion.siguiente(position)
		enemigo1.mover()
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

	//COMBATE/PELEA
    var property enemigoCombatiendo = null //el enemigo con quien está en combate
	var esTurno = false //si es su turno en un combate

    method estaEnCombate(condicion){
        estaEnCombate = condicion
    }

    method atacarPre() {
        esTurno = true
    }

	method atacar() {
        self.validarCombate() // para que no le pegue a x enemigo cuando no esta peleando

		enemigoCombatiendo.recibirDanho(armaActual.danho()) //todo esto solo se llega a ejecutar posterior al cambio de turno en una pelea
		armaActual.realizarActualizacionDeArmas()

        esTurno = false //para que no pueda atacar al enemigo cuando no es su turno

		combate.cambiarTurnoA(enemigoCombatiendo)   //el pj termina de atacar y cambia el turno al enemigo
	}

	method actualizarArmaActual() { //esto se ejecuta solamente cuando se descarta el arma actual
		if(bolsa.size()>1) {
			armaActual = bolsa.get(1); //pone la 2da de la bolsa como el arma actual
		} else {
			armaActual = mano
		}
	}

    method validarCombate() {
        if(!estaEnCombate && !esTurno){
            self.error("No puedo atacar ahora")
        }
    }

	method recibirDanho(cantidad) {
		vida -= cantidad
	}
	
	method morir() {
		position = game.at(2,2)
        vida = 450
	}

	method aumentarVida(vidaSumada) {
		vida += vidaSumada
	}

}

//ESTADOS

object sinArma {

	method imagenParaPersonaje() {
		return ""
	}

}

object conArma {

=======
}

//ESTADOS

object sinArma {

	method imagenParaPersonaje() {
		return ""
	}

}

object conArma {
	method imagenParaPersonaje() {
		return personaje.armaActual().imagenParaPersonaje()
	}

}


