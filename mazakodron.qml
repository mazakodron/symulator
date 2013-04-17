import Qt 4.7

Rectangle {
  
    signal requestDraw(double x1, double y1, double x2, double y2);

    property bool mazak_down: false;
    property bool robot_hidden: false;
    property bool robot_transparent: false;
    property double constROBOT_R: 119.5;
    property double constWHEEL_R: 18.0;
    property double constREV_STEP: 1.0/4096.0;
    property double constSTEP: 0.220875/8.0;
    
    property int counter: 0;
    
    Timer {
      id: timer
      interval: 250;
      running: false;
      repeat: false;
      triggeredOnStart: true;
      onTriggered: drawing.source="image://mazakodron/drawing"+counter
    }

    function draw(x1, y1, x2, y2) {
      if (mazak_down) {
        requestDraw(x1, y1, x2, y2)
        counter++;
        timer.start()
      }
    }
    function goForward() {
      var oldXPos = mazak.xPos, oldYPos = mazak.yPos;
      var angle = (mazak.rotation/360)*2*3.14;
      mazak.xPos += (-constSTEP * Math.sin(angle))/297;
      mazak.yPos += (constSTEP * Math.cos(angle))/210;
      draw(oldXPos, oldYPos, mazak.xPos, mazak.yPos);
    }

    function goBackward() {
      var oldXPos = mazak.xPos, oldYPos = mazak.yPos;
      var angle = (mazak.rotation/360)*2*3.14;
      mazak.xPos -= (-constSTEP * Math.sin(angle))/297;
      mazak.yPos -= (constSTEP * Math.cos(angle))/210;
      draw(oldXPos, oldYPos, mazak.xPos, mazak.yPos);
    }

    function rotateLeft() {
      mazak.rotation -= (constWHEEL_R*constREV_STEP*360)/constROBOT_R;
    }

    function rotateRight() {
      mazak.rotation += (constWHEEL_R*constREV_STEP*360)/constROBOT_R;
    }

    function liftMazak() {
      mazak_down = false;
      timer.restart()
    }

    function dropMazak() {
      mazak_down = true;
    }

    function hideRobot() {
      robot_hidden = true;
    }

    function showRobot() {
      robot_hidden = false;
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
        id: drawing;
        anchors.fill: parent;
        source: "image://mazakodron/drawing";
        smooth: true;
        asynchronous: false;
      }
      Image {

        property double xPos: 0;
        property double yPos: 0;

        id: mazak;

        opacity: 1;
        x: xPos*paper.width;
        y: yPos*paper.height;
        width: 0;
        height: 0;
        rotation: 0;

        states:[ State {
          name: "hidden"; when: robot_hidden == true;
          PropertyChanges {
            target: mazak;
            opacity: 0
          }
        },
        State {
          name: "transparent"; when: robot_transparent == true;
          PropertyChanges {
            target: mazakodron;
            opacity: 0.5
          }
        }
        ]
        
        transitions: [ Transition {
          from: "*"; to: "hidden"; reversible: true;
          SequentialAnimation {
            NumberAnimation { target: mazak; property: "opacity"; duration: 5000; easing.type:Easing.InQuad; }
          }
        }, Transition {
          from: "*"; to: "transparent"; reversible: true;
          SequentialAnimation {
            NumberAnimation { target: mazakodron; property: "opacity"; duration: 500;}
          }
        }]
        
        
        
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
      onClicked: { robot_transparent = !robot_transparent;}
    }
}
