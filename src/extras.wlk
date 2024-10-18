import wollok.game.*
import personaje.*
import randomizer.*
import paleta.*
import enemigos.*

object listaDeObjetos {

    method position() {
		return game.at(28,23)
	}

	method image() { 
		return "listaDeObj" + self.estado().imagenParaLista() + "-64Bits.png"
	}

    method estado() {
        if(personaje.bolsa().size()==3) {
            return listaCon3
        } else if (personaje.bolsa().size()==2) {
            return listaCon2
        } else if (personaje.bolsa().size()==1) {
            return listaCon1
        } else {
            return listaCon0
        }
    }

    method text() {return personaje.armaActual()}
    method textColor() = paleta.rojo()

}

object listaCon3 {

    method imagenParaLista() {
        return "3"
    }

}

object listaCon2 {

    method imagenParaLista() {
        return "2"
    }

}

object listaCon1 {

    method imagenParaLista() {
        return "1"
    }

}

object listaCon0 {

    method imagenParaLista() {
        return "0"
    }

}

object dungeon {

    const property enemigos = []

    method registrarEnemigo(enemigo) {
        enemigos.add(enemigo)
    }

    method validarDentro(posicion) {
        if (!self.estaDentro(posicion)) {
            self.error("Soy una pared. No podés pasarme.") //entiendo que al no tener visual ni posición esto nunca se ve. igual mejor así!
        }
    }

    method estaDentro(posicion) {
        return posicion.x().between(2, game.width() - 3) && posicion.y().between(2, game.height() - 6) 
    }

    method accionEnemigos() {
        enemigos.forEach({enemigo => enemigo.mover()})
    }
}

class Corazon {
    const property position = randomizer.posicionRandomDeCorazon()
    const property image = "corazon-32Bits.png"
    const vidaOtorgada = 150

    // El personaje colisiona con el corazón y su vida aumenta
    method colisiono(personaje){
        personaje.aumentarVida(vidaOtorgada)
        game.removeVisual(self)
    }

}
