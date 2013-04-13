import Qt 4.7

Rectangle {

    property bool mazak_down: false;

    function moveMazakodron(x, y, angle) {

    }

    function liftMazak() {
      mazak_down = false;
    }

    function dropMazak() {
      mazak_down = !mazak_down; //true;
    }

    id: view
    anchors.fill: parent;
    color: "grey";

    Rectangle {
      id: paper;
      x: view.width/2 - paper.width/2;
      y: view.height/2 - paper.height/2;
      width: Math.min(view.width, view.height*1.41)*0.75;
      height: Math.min(view.height, view.width*0.7)*0.75;
      color: "white";

      Image {
        id: mazak;

        x: 0;//.3*paper.width;
        y: 0;//.3*paper.height;
        width: 0;
        height: 0;
        rotation: 0;

        Image {
            id: mazakodron;
            x: -0.435*paper.width;
            y: -0.27*paper.height;
            width: 0.8825*paper.width;
            height: 0.5505*paper.height;
            source: "mazakodron.png";
            asynchronous: true;
            smooth: true;
        }

        Image {

          
          id: mazak_img;
          x: -0.036*paper.width;
          y: -0.052*paper.height-(0.12*paper.height);
          width: 0.064*paper.width+(0.01*paper.width);
          height: 0.11*paper.height+(0.01*paper.width);
          source: "mazak.png";
          asynchronous: true;
          smooth: true;

          states: State {
            name: "down"; when: mazak_down == true;
            PropertyChanges {
              target: mazak_img;
              x: -0.036*paper.width;
              y: -0.052*paper.height;
              width: 0.064*paper.width;
              height: 0.11*paper.height;
            }
          }
          
         transitions: Transition {
            from: ""; to: "down"; reversible: true;
            SequentialAnimation {
              NumberAnimation { target: mazak_img; properties: "x,y,width,height"; duration: 100; easing.type:Easing.InQuad; }
            }
            
          }
          
        }
        
        
      }

    }
    
    MouseArea {
      anchors.fill: parent
      onClicked: dropMazak()
    }
}
