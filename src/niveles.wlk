import wollok.game.*
import personaje.*
import extras.*
import enemigos.*
import randomizer.*
import posiciones.*
import paleta.*
import armas.*
import pelea.*
import mapa.*

object nivel1 inherits Nivel(enemigosSpawneados = 1) {

    override method tablero() { // 25x30 (X,Y)
       return   [ 
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,e,_,_,_,_,_,_,c,b,_,_,_,_,_,_,z,_,_,_,_,_,_,_,_,a,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,p,_,_,_,x,x],
                [x,x,b,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,g,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,b,b,_,_,_,_,_,_,_,_,a,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,g,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,a,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,x,x],
                [x,x,_,_,_,b,c,_,_,_,_,a,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,m,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x] 
                ].reverse()
    }

    override method pasarNivel() {
        super()
        nivel2.dibujar()
    }
}

object nivel2 inherits Nivel(enemigosSpawneados = 1){
    override method tablero() {
       return   [ 
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,m,b,_,_,_,_,_,_,_,_,_,_,_,z,_,_,_,_,_,_,_,_,_,_,_,g,x,x],
                [x,x,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,c,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,g,_,_,_,_,_,_,_,b,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,_,e,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,c,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,g,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,a,_,_,_,_,x,x],
                [x,x,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,x,x],
                [x,x,m,c,_,_,_,_,_,_,a,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,m,c,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x]
                ].reverse()
    }
     override method pasarNivel() {
        //self.validarPasarNivel()
        super()
        arenaJefe.dibujar()
    }
}

object arenaJefe inherits Nivel(enemigosSpawneados = 1) {
        override method tablero() {
       return   [ 
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,b,x,x],
                [x,x,b,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,g,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,g,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,j,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,c,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,b,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,m,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x]
                ].reverse()
    }

     override method pasarNivel() { //no olvidemos que falta tocar esto para que salga la pantalla final de victoria!!
        //self.limpiarTablero() este vuelve a hacer dungeon.dibujar(). el de abajo solo borra y listo. así mejor, no??
        mapa.limpiar()
        game.stop()
    }
}