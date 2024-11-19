import wollok.game.*
import personaje.*
import extras.*
import enemigos.*
import randomizer.*
import posiciones.*
import paleta.*
import armas.*
import paredes.*
import pelea.*
import mapa.*

class Animacion {
    method maxFrame(entidad)

    method cambiarAnimacion(entidad) {

        const newFrame = (entidad.frame() + 1) % self.maxFrame(entidad)
        entidad.frame(newFrame)
    }

    method tipoPersonaje() {
        return ""
    }

}

object animacionEstatica inherits Animacion {

    override method maxFrame(entidad) {
        return entidad.maxFrameEstatica()
    }

    method tipo() {
        return ""
    }

}

object animacionCombate inherits Animacion {

    override method maxFrame(entidad) {
        return entidad.maxFrameCombate()
    }

    method tipo() {
        return "ataque"
    }

    override method tipoPersonaje() {
        return "ataque" + personaje.armaActual().imagenParaPersonaje() 
    }

}

object animacionCurar inherits Animacion {

    override method maxFrame(entidad) {
        return 4
    }

    override method tipoPersonaje() {
        return "curar" 
    }

}

object animacionMuerte inherits Animacion {

    override method maxFrame(entidad) {
        return entidad.maxFrameMuerte()
    }

    method tipo() {
        return "muerte"
    }

    override method tipoPersonaje() {
        return "muerte"
    }

}