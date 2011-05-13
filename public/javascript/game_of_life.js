/**********************************************************************************
**********************************************************************************/
Array.matrix = function (m, n, initial) {
  var a, i, j, mat = [];
  for (i = 0; i < m; i += 1) {
    a = [];
    for (j = 0; j < n; j += 1) {
      a[j] = 0;
    }
    mat[i] = a;
  }
  return mat;
};

/**********************************************************************************
**********************************************************************************/
Life = {
    
    /*-------------------------------------------------------------------------------*/
    CELL_SIZE: 8;
    X: 320;
    Y: 320;
    WIDTH: X / CELL_SIZE;
    HEIGHT: Y / CELL_SIZE;
    DEAD: 0;
    ALIVE: 1;
    DELAY: 500;
    STOPPED: 0;
    RUNNING: 1;

    /*-------------------------------------------------------------------------------*/
    minimum: 2;
    maximum: 3;
    spawn: 3;

    /*-------------------------------------------------------------------------------*/
    state: Life.STOPPED;
    interval: null;
    counter: 0;

    grid: Array.matrix(HEIGHT, WIDTH, 0);

    /*-------------------------------------------------------------------------------*/
    updateState: function() {
      var neighbours;

      var nextGenerationGrid = Array.matrix(HEIGHT, WIDTH, 0);

      for (var h = 0; h < HEIGHT; h++) {
        for (var w = 0; w < WIDTH; w++) {
          neighbours = this.calculateNeighbours(h, w);
          if (grid[h][w] !== DEAD) {
            if ((neighbours >= minimum) &&
              (neighbours <= maximum)) {
                nextGenerationGrid[h][w] = ALIVE;
            }
          } else {
            if (neighbours === spawn) {
              nextGenerationGrid[h][w] = ALIVE;
            }
          }
        }
      }
      copyGrid(nextGenerationGrid, grid);
      counter++;
    },
    calculateNeighbours: function(y, x) {
      var total = (grid[y][x] !== DEAD) ? -1 : 0;
      for (var h = -1; h <= 1; h++) {
        for (var w = -1; w <= 1; w++) {
          if (grid
            [(HEIGHT + (y + h)) % HEIGHT]
            [(WIDTH + (x + w)) % WIDTH] !== DEAD) {
                total++;
          }
        }
      }
      return total;
    },
    copyGrid: function(source, destination) {
      for (var h = 0; h < HEIGHT; h++) {
        destination[h] = source[h].slice(0);
      }
    },
}

/**********************************************************************************
**********************************************************************************/
function gameOfLife() {

  function() {

    function Cell(row, column) {
      this.row = row;
      this.column = column;
    };

    var gridCanvas = document.getElementById("grid");

    function update() {
      Life.updateState();
      updateAnimations();
    };

    function updateAnimations() {
      for (var h = 0; h < Life.HEIGHT; h++) {
        for (var w = 0; w < Life.WIDTH; w++) {
          if (Life.grid[h][w] === Life.ALIVE) {
            context.fillStyle = "#000";
          } else {
            context.fillStyle = "#eee";
            //context.clearRect();
          }
          context.fillRect(
            w * Life.CELL_SIZE +1,
            h * Life.CELL_SIZE +1,
            Life.CELL_SIZE -1,
            Life.CELL_SIZE -1);
        }
      }
      counterSpan.innerHTML = Life.counter;
    };

    if (gridCanvas.getContext) {
      var context = gridCanvas.getContext('2d');
      var offset = Life.CELL_SIZE;

      for (var x = 0; x <= Life.X; x += Life.CELL_SIZE) {
        context.moveTo(0.5 + x, 0);
        context.lineTo(0.5 + x, Life.Y);
      }
      for (var y = 0; y <= Life.Y; y += Life.CELL_SIZE) {
        context.moveTo(0, 0.5 + y);
        context.lineTo(Life.X, 0.5 + y);
      }
      context.strokeStyle = "#fff";
      context.stroke();

    } 
  }
};
