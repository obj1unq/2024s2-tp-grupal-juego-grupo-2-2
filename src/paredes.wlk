import wollok.game.*
import personaje.*
class Pared {

    var property position 
    
    method esSolido() {
        return true
    }

    method colisiono(personaje) {
        personaje.validarMover()
    }

}

object borde {

    const ancho = game.width() - 2
    const largo = game.height() - 2

    const paredes = []

    method cargar() {
        (0 .. ancho).forEach({n => paredes.add(new Pared (position = game.at(n, largo)))}) //borde arriba
    }

    method mostrar() {
        paredes.forEach({pared => game.addVisual(pared)})
    }
}