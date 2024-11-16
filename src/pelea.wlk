import wollok.game.*
import posiciones.*
import extras.*
import paleta.*
import enemigos.*
import personaje.*
import mapa.*

object combate {

    var property entidadAtacando = null //aquel que tiene el turno para atacar
    const heroe = personaje
    var hayCombate = false

    method iniciarCombate(){
        heroe.enemigoCombatiendo(entidadAtacando)
        hayCombate = true
        heroe.estaEnCombate(true)   //en personaje se puede poner combate.hayCombate() en vez de mandarle esto al personaje
        barraEstadoPeleas.enemigo(entidadAtacando)
        barraEstadoPeleas.aparecerJuntoADemasBarras()
    }

    method cambiarTurnoA(entidad){
        entidadAtacando = entidad
        self.entidadAtaca() //acá se valida si el que ahora tiene el turno sigue con vida y, si es así, este realiza su ataque
    }

    method entidadAtaca() {  
        self.revisarFinDeCombate()      
        self.validarCombate()
        //game.schedule(200, {entidadAtacando.atacarPre()})
        entidadAtacando.atacarPre()
    }

    method revisarFinDeCombate() {
        if(entidadAtacando.salud() <= 0) {
            hayCombate = false
            heroe.estaEnCombate(false)
            barraEstadoPeleas.desaparecerJuntoADemasBarras()
            entidadAtacando.morir()
        }
    }

    method validarCombate() {
        if(!hayCombate){
            self.error("")
        }
    }
    method hayCombate(cond){
        hayCombate = cond
    }

}

object barraEstadoPeleas {

    var property enemigo = null
    var property heroe = personaje

    method image() {
        return "pruebaBarra4.png"
    }

    method position() = game.at(heroe.position().x() - 2, heroe.position().y() + 4)

    // aparece todo lo que tiene que mostrar la barra de estado
    method aparecerJuntoADemasBarras() {
            game.addVisual(self)
            game.addVisual(saludPersonaje)
            game.addVisual(saludEnemigo)
            game.addVisual(durabilidad)
            //game.addVisual(turnoTest)
    }

    // desaparece la barra y todo lo que muestra tras darse la muerte del personaje o el enemigo
    method desaparecerJuntoADemasBarras() {
        game.removeVisual(self)
        game.removeVisual(saludPersonaje)
        game.removeVisual(saludEnemigo)
        game.removeVisual(durabilidad)
        //game.removeVisual(turnoTest)
    }

}

object saludPersonaje {

    method text() = " salud PJ: " + barraEstadoPeleas.heroe().salud().toString()
    method textColor() = paleta.rojo()

    method position() = barraEstadoPeleas.position().down(1)

}

object saludEnemigo {

    method text() = " salud EN: " + barraEstadoPeleas.enemigo().salud().toString()
    method textColor() = paleta.azul()

    method position() = saludPersonaje.position().right(4)

}

object durabilidad {

    method position() = barraEstadoPeleas.position().down(2).right(2)
    method text() = "Durabilidad arma actual: " + personaje.armaActual().durabilidad().toString() //+ "\n Nivel: " + personaje.armaActual().nivel().toString()
    method textColor() = paleta.rojo()

}

object turnoTest {
    method position() = game.at(1,16)//ataque.position().right(5)
    method text() = "Turno De: " + combate.entidadAtacando()
    method textColor() = paleta.rojo()
}
