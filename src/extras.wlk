import wollok.game.*
import personaje.*
import randomizer.*
import paleta.*
import enemigos.*

object dungeon {

    const property enemigos = []

    method registrarEnemigo(enemigo) {
        enemigos.add(enemigo)
    }

    method validarDentro(posicion) {
        if (!self.estaDentro(posicion)) {
            self.error("") //entiendo que al no tener visual ni posición, este mensaje de error nunca se ve.
        }
    }

    method estaDentro(posicion) {
        return posicion.x().between(2, game.width() - 3) && posicion.y().between(2, game.height() - 6) 
    }

    method accionEnemigos() {
        enemigos.forEach({enemigo => enemigo.reaccionarAMovimiento()})
    }

    method hayEnemigoEn(celda){
        return enemigos.any({enemigo => enemigo.position() == celda})
    }

}

//To do: hacer un objeto con el visual de las armas que se tienen (en vez de los números, como ahora) que remplace a listaDeObjetos
object listaDeObjetos {

    method position() {
		return game.at(28,23)
	}

	method image() { 
		return "listaDeObj" + self.imagenSegunEstado() + "-64Bits.png"
	}

    method imagenSegunEstado() {
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

/* el profe dijo que no estaba tan piola hacer objs estados si solo los vamos a usar para retornar el string para el image
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
*/

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

object vidas {

}

