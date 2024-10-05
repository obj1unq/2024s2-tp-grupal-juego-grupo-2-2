import wollok.game.*
import personaje.*
import randomizer.*
import paleta.*

object listaDeObjetos {

    method position() {
		return game.at(29,24)
	}

	method image() { 
		return "listaDeObj" + self.estado() + "-32Bits.png"
	}

    method estado() {
        if(personaje.bolsa().size()==3) {
            return "3"
        } else if (personaje.bolsa().size()==2) {
            return "2"
        } else if (personaje.bolsa().size()==1) {
            return "1"
        } else {
            return "0"
        }
    }

    method text() {return personaje.armaActual()}
    method textColor() = paleta.rojo()

}

object dungeon {

    method validarDentro(posicion) {
        if (!self.estaDentro(posicion)) {
            self.error("Soy una pared. No podés pasarme.")
        }
    }

    method estaDentro(posicion) {
        return posicion.x().between(2, game.width() - 3) && posicion.y().between(2, game.height() - 6) 
    }
}
