import wollok.game.*
import posiciones.*
import extras.*
import paleta.*
import enemigos.*
import armas.*
import randomizer.*
import pelea.*
import personaje.*
import niveles.*

class Nivel {

   const property enemigosSpawneados

    method tablero()
 
    method dibujar() {
    console.println("Dibujando...")

        game.height(self.tablero().size())
        game.width(self.tablero().get(0).size())


        (0..game.width() - 1).forEach({ x =>
            (0..game.height() -1).forEach({y =>
                self.tablero().get(y).get(x).dibujarEn(game.at(x,y))
            })
        })
        
        console.println("Dibujado.")
        game.addVisual(personaje)

        game.addVisual(menuInformativo)
       
    }


    method limpiarTablero() {
        console.println("Limpiando...")

        game.height(self.tablero().size())
        game.width(self.tablero().get(0).size())

        game.allVisuals().forEach( { visual => game.removeVisual(visual)})

        console.println("Limpiado")

        game.addVisual(gestorDeFondo)
    }

    method pasarNivel(){
        puerta.reiniciarPuerta()
        dungeon.siguienteNivel()
        self.limpiarTablero()
        dungeon.dibujar()
    }

} 

object b { //barriles

    method dibujarEn(position) {
        fabricaDeBarriles.agregarNuevoBarril(position)
    }
}

object m { //mesa
    method dibujarEn(position) {
        fabricaDeMesas.agregarNuevaMesa(position)
    }
}

object c{ //cajas
    method dibujarEn(position) {
        fabricaDeCajas.agregarNuevaCaja(position)
    }
}

object z { //puerta
    method dibujarEn(position) {
        puerta.position(position)
    }
}

object a { //arma
    method dibujarEn(position){
       randomizer.agregarArmaRandom(position)
    }
}

object j {//jefe
    method dibujarEn(position){
        jefeFase1.position(position)    
        game.addVisual(jefeFase1)
        dungeon.registrarEnemigo(jefeFase1)
    }
}

object o { // ojo
    method dibujarEn(position){
        fabricaDeOjoVolador.agregarNuevoEnemigo(position,150, 40)
    }

}

object g { // goblin
    method dibujarEn(position){
        fabricaDeGoblin.agregarNuevoEnemigoCon(position, 95, 37)
    }
}

object e{ //esqueleto
    method dibujarEn(position){
        fabricaDeEsqueleto.agregarNuevoEnemigo(position, 200, 43,  3)
    }
}

object p { //pocion de salud
    method dibujarEn(position){
        fabricaDePocion.agregarNuevaPocion(position)
    }
}


object _ { // donde se pueden poner cosas
    method dibujarEn(_position){

    }
}

object x { //donde no se pueden poner cosas porque ahi pared
       method dibujarEn(_position){

    }
}


object puerta {

    var property position =  game.at(16,19) 
    var estado = puertaCerrada


    method image() {
        return "puertaNueva2.png"
    }

    method colisiono(personaje) {
        self.validarEntrar()
        personaje.pasarNivel()

    }

    method abrirPuerta(){
        estado = puertaAbierta
    }

    method validarEntrar(){
        if(!estado.sePuedePasar()){
            self.error("Se deben matar a todos lo enemigos!")
        }
    }

    method reiniciarPuerta(){
        estado = puertaCerrada
        game.sound("cerrarPuerta.mp3").play()
        console.println("estaCerrada")
    }

}

object puertaAbierta {
    method sePuedePasar(){
        return true
    }
}


object puertaCerrada {
    method sePuedePasar(){
        return false
    }
}