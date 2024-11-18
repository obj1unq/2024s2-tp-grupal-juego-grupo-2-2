import wollok.game.*
import personaje.*
import randomizer.*
import paleta.*
import enemigos.*
import mapa.*

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

    method sacarEnemigo(enemigo) {
        enemigos.remove(enemigo)
    }

    //animacion enemigos

    method animacionEnemigos(){
        enemigos.forEach({enemigo => enemigo.cambiarAnimacion()})
    }

}

object gestorDeFondo {
    var property image = "fondoNivel1.png"

    method position() {
        return game.at(0,0)
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

class Pocion {
    const property position = randomizer.posicionRandomDePocion()
    const property image = "pocion-32Bits.png"

    // El personaje colisiona con la poción y su salud aumenta
    method colisiono(personaje){
        personaje.agregarPocion()
        game.removeVisual(self)
    }

}

object fabricaDePocion {

    method agregarNuevaPocion() {
        const pocion = new Pocion()
        game.addVisual(pocion)
    }
    
}

object salud {
    method position() { return game.at(1, game.height()-1) }
    method text() { return "salud: " + personaje.salud().toString() }
    method textColor() { return paleta.rojo() }
}

object vidas {
    method position() { return game.at(4, game.height()-1) }

    method image() { 
		return "vidas" + self.imagenSegunEstado() + ".png"
	}

    method imagenSegunEstado() {
        if(personaje.cantVidas()==3) {
            return "3"
        } else if (personaje.cantVidas()==2) {
            return "2"
        } else {
            return "1"
        }
    }

}

object pociones {
    method position() { return game.at(8, game.height()-1) }

    method image() { 
		return "pociones" + self.imagenSegunEstado() + ".png"
	}

    method imagenSegunEstado() {
        if(personaje.cantPociones()==3) {
            return "3"
        } else if (personaje.cantPociones()==2) {
            return "2"
        } else if (personaje.cantPociones()==1) {
            return "1"
        } else {
            return "0"
        }
    }

}

object barraFuerza {
    method position() { return game.at(12, game.height()-1) }

    method image() { 
		return "barraDeFuerza" + self.imagenSegunEstado() + ".png"
	}

    method imagenSegunEstado() {
        if(personaje.cantPociones()==3) {
            return "3"
        } else if (personaje.cantPociones()==2) {
            return "2"
        } else if (personaje.cantPociones()==1) {
            return "1"
        } else {
            return "0"
        }
    }
}