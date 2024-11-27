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

object nivel1 inherits Nivel(enemigosSpawneados = 4) {

    override method tablero() { // 25x30 (X,Y)
       return   [ 
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,_,_,_,_,_,_,_,c,b,_,_,_,_,_,_,z,_,_,_,_,_,_,_,_,a,_,x,x],
                [x,x,_,b,c,_,g,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,o,_,_,x,x],
                [x,x,b,_,c,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,p,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,m,c,_,_,_,_,x,x],
                [x,x,_,_,_,b,_,_,_,_,_,_,_,_,c,b,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,b,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,b,b,_,_,_,_,_,_,_,c,a,b,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,g,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,a,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,b,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,x,x],
                [x,x,_,_,_,b,c,_,_,_,_,a,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,m,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x] 
                ].reverse()
    }

    override method pasarNivel() {
        super()
        nivel2.dibujar()
    }
}

object nivel2 inherits Nivel(enemigosSpawneados = 6){
    override method tablero() {
       return   [ 
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,m,b,_,_,_,_,_,_,m,_,_,_,_,z,_,b,c,_,_,_,_,_,a,_,_,c,x,x],
                [x,x,c,_,_,g,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,o,_,_,x,x],
                [x,x,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,c,c,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,o,_,_,_,_,_,_,_,b,_,_,_,_,_,_,_,c,m,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,c,b,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,_,_,_,x,x],
                [x,x,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,c,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,b,b,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,c,g,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,b,_,_,_,_,x,x],
                [x,x,_,_,_,_,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,m,_,a,_,_,_,_,x,x],
                [x,x,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,b,x,x],
                [x,x,m,c,_,e,_,_,a,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,m,c,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x]
                ].reverse()
    }
     override method pasarNivel() {
        super()
        arenaJefe.dibujar()
    }
}

object arenaJefe inherits Nivel(enemigosSpawneados = 4) {
        override method tablero() {
       return   [ 
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,_,_,c,_,_,_,_,_,_,_,c,c,_,_,_,_,_,m,_,_,_,_,_,_,c,b,x,x],
                [x,x,b,m,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,a,_,_,_,_,_,p,b,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,a,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,b,b,_,_,_,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,c,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,a,b,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,m,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,j,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,c,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,b,b,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,_,b,b,_,_,_,c,c,_,_,_,_,_,_,_,b,b,_,_,_,p,x,x],
                [x,x,_,_,_,p,_,_,c,_,_,_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,x,x],
                [x,x,_,_,_,_,_,g,_,_,_,_,_,_,_,_,_,_,_,b,a,_,_,_,_,_,_,c,x,x],
                [x,x,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,c,m,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
                [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x]
                ].reverse()
    }

     override method pasarNivel() { 
        self.limpiarTablero()
        dungeon.detenerMusicaAmbiente()
        game.sound("musicaFinal.mp3").play()
        gestorDeFondo.image("fondoFinal1.png")
        game.schedule(7000, {gestorDeFondo.image("fondoFinal4.png")})
        game.schedule(14000, {gestorDeFondo.image("fondoFinal5.png")})
        game.schedule(15000, {game.stop()})
    }
}