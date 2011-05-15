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
cell object
**********************************************************************************/
function Cell(row, column) {
  this.row = row;
  this.column = column;
}

/**********************************************************************************
game
**********************************************************************************/
Life = {
    
  /*-------------------------------------------------------------------------------*/
  DEAD: 0,
  ALIVE: 1,
  DELAY: 1000,
  STOPPED: 0,
  RUNNING: 1,

  /*-------------------------------------------------------------------------------*/
  CELL_SIZE: 20,
 
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

  /*-------------------------------------------------------------------------------*/
  updateState: function() {
    var neighbours;
    var nextGenerationGrid = Array.matrix(this.height, this.width, 0);
    for (var h = 0; h < this.height; h++) {
      for (var w = 0; w < this.width; w++) {
        neighbours = this.calculateNeighbours(h, w);
        if (grid[h][w] !== DEAD) {
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
    var total = (grid[y][x] !== DEAD) ? -1 : 0;
    for (var h = -1; h <= 1; h++) {
      for (var w = -1; w <= 1; w++) {
        if (this.grid[(this.height + (y + h)) % this.height][(this.width + (x + w)) % this.width] !== this.DEAD) {
          total++;
        }
      }
    }
    return total;
  },
  initGrid: function() {
    var doc_height = $(document).height(),
        doc_width  = $(document).width(),
        gridCanvas = getCanvas();
    this.height = Math.floor(doc_height / this.CELL_SIZE) + 1;
    this.width  = Math.floor(doc_width / this.CELL_SIZE) + 1;
    gridCanvas.width  = doc_width;
    gridCanvas.height = doc_height;
    this.grid =  Array.matrix(this.height, this.width, 0);
    var is_alive = 1;
    for (var h = 0; h < this.height; h++) {
      for (var w = 0; w < this.width; w++) {
        if (is_alive) {
          this.grid[h][w] = this.ALIVE
          is_alive = 0;
        } else {
          is_alive = 1;
          this.grid[h][w] = this.DEAD
        }
      }
    }
  },
  copyGrid: function(source, destination) {
    for (var h = 0; h < this.height; h++) {
      destination[h] = source[h].slice(0);
    }
  }
}

/**********************************************************************************
initialize
**********************************************************************************/
function gameOfLife() {
  var gridCanvas = getCanvas();
  if (gridCanvas.getContext) {
    Life.initGrid();
    startGame();
  } 
}

/**********************************************************************************
game control
**********************************************************************************/
function startGame() {
  Life.interval = setInterval(function() {
    update();
  }, Life.DELAY);
  Life.state = Life.RUNNING;
}

/*-------------------------------------------------------------------------------*/
function stopGame() {
  clearInterval(Life.interval);
  Life.state = Life.STOPPED;
}

/*-------------------------------------------------------------------------------*/
function update() {
  // Life.updateState();
  updateAnimations();
}

/*-------------------------------------------------------------------------------*/
function getCanvas() {
  return document.getElementById("game-of-life");
}

/*-------------------------------------------------------------------------------*/
function updateAnimations() {
  var gridCanvas = getCanvas(),
      context = gridCanvas.getContext('2d');
  for (var h = 0; h < Life.height; h++) {
    for (var w = 0; w < Life.width; w++) {
      if (Life.grid[h][w] === Life.ALIVE) {
        context.fillStyle = "#DDD";
      } else {
        context.fillStyle = "#EEE";
      }
      context.fillRect(w*Life.CELL_SIZE, h*Life.CELL_SIZE, Life.CELL_SIZE, Life.CELL_SIZE);
    }
  }
};
