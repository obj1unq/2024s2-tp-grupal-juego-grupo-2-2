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
    method maxFrame(enemigo)

    method cambiarAnimacion(enemigo) {

        const newFrame = (enemigo.frame() + 1) % self.maxFrame(enemigo)
        enemigo.frame(newFrame)
    }

}

object animacionEstatica inherits Animacion {

    override method maxFrame(enemigo) {
        return enemigo.maxFrameEstatica()
    }

    method tipo() {
        return ""
    }

}

object animacionCombate inherits Animacion {

    override method maxFrame(enemigo) {
        return 8
    }

    method tipo(){
        return "ataque"
    }

}
object animacionMuerte inherits Animacion {

    override method maxFrame(enemigo) {
        return 4
    }

    method tipo(){
        return "muerte"
    }

}