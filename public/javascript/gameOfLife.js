/**********************************************************************************
utils
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
}

/**********************************************************************************
game
**********************************************************************************/
Life = {
    
  /*-------------------------------------------------------------------------------*/
  DEAD: 0,
  ALIVE: 1,
  DELAY: 750,

  /*-------------------------------------------------------------------------------*/
  CELL_SIZE: 20,
  INIT_DEAD: 50,
 
  /*-------------------------------------------------------------------------------*/
  minimum: 2,
  maximum: 3,
  spawn: 3,
  state: this.STOPPED,
  interval: null,
  counter: 0,
  height: null,
  width: null,
  grid: null,
  cell_image: new Image(),

  /*-------------------------------------------------------------------------------*/
  updateState: function() {
    var neighbours;
    var nextGenerationGrid = Array.matrix(this.height, this.width, 0);
    for (var h = 0; h < this.height; h++) {
      for (var w = 0; w < this.width; w++) {
        neighbours = this.calculateNeighbours(h, w);
        if (this.grid[h][w] !== this.DEAD) {
          if ((neighbours >= this.minimum) && (neighbours <= this.maximum)) {
            nextGenerationGrid[h][w] = this.ALIVE;
          }
        } else {
          if (neighbours === this.spawn) {
            nextGenerationGrid[h][w] = this.ALIVE;
          }
        }
      }
    }
    this.copyGrid(nextGenerationGrid, this.grid);
  },
  calculateNeighbours: function(y, x) {
    var total = (this.grid[y][x] !== this.DEAD) ? -1 : 0;
    for (var h = -1; h <= 1; h++) {
      for (var w = -1; w <= 1; w++) {
        if (this.grid[(this.height + (y + h)) % this.height][(this.width + (x + w)) % this.width] !== this.DEAD) {
          total++;
        }
      }
    }
    return total;
  },
  initLife: function() {
    var can_height = $(document).height(),
        can_width  = $(document).width(),
        gridCanvas = this.getCanvas();
    this.height = Math.floor(can_height / this.CELL_SIZE) + 1;
    this.width  = Math.floor(can_width / this.CELL_SIZE) + 1;
    gridCanvas.width  = can_width;
    gridCanvas.height = can_height;
    this.grid =  Array.matrix(this.height, this.width, 0);
    this.initGrid();
    this.cell_image.onload = function(){startGame();};
    this.cell_image.src = '/company/life-cell.png';
  },
  initGrid: function() {
    var die;
    for (var h = 0; h < this.height; h++) {
      for (var w = 0; w < this.width; w++) {
        die = Math.floor(100*Math.random());
        if (die > this.INIT_DEAD) {
          this.grid[h][w] = this.ALIVE
        } else {
          this.grid[h][w] = this.DEAD
        }
      }
    }
  },
  copyGrid: function(source, destination) {
    for (var h = 0; h < this.height; h++) {
      destination[h] = source[h].slice(0);
    }
  },
  update: function() {
    this.updateState();
    this.updateAnimations();
  },
  getCanvas: function() {
    return document.getElementById("game-of-life");
  },
  updateAnimations: function() {
    var gridCanvas = this.getCanvas(),
        context = gridCanvas.getContext('2d'),
        xpos, ypos;
    for (var h = 0; h < this.height; h++) {
      for (var w = 0; w < this.width; w++) {
        xpos = w*this.CELL_SIZE;
        ypos = h*this.CELL_SIZE;
        context.clearRect(xpos, ypos , this.CELL_SIZE, this.CELL_SIZE)
        if (this.grid[h][w] === this.ALIVE) {
          context.drawImage(this.cell_image, xpos, ypos);
        }
      }
    }
  }
}

/**********************************************************************************
initialize
**********************************************************************************/
function gameOfLife() {
  var gridCanvas = Life.getCanvas();
  if (gridCanvas.getContext) {
    Life.initLife();
  } 
}

function startGame() {
  Life.interval = setInterval(function() {
    Life.update();
  }, Life.DELAY);
}

