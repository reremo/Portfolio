using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class GameSystem : MonoBehaviour
{
      bool isDevelop = true;//フリック操作を使うかどうか
    int[] playerPosition = {0,0};
    public static int defaultPlayerX = 2;
    public static int defaultPlayerY = 2;
    int playerX = defaultPlayerX;
    int playerY = defaultPlayerY;
    public static int playerPower = 2;
    int spawnEnemyPower = 0;//のちにランダムで設定
    bool isBeatEnemy = false;
    const int FIELD_SIZE = 5;
     bool isHavingAnimation = false;//アニメーションを実行中か否か
    int[] moveInfo = {0,0};//移動情報を保持しアニメーションに反映
    int animationFrame = 0;//何フレーム目かを管理
    int fullAnimationFrame = 10;//全体フレームを管理
    Color playerColor = Color.red;
    Color blockColor = Color.blue;
    Color enemyColor = Color.yellow;
  
    [SerializeField] GameObject _block = null;
  
    private Block[,] _fieldBlocks = new Block[FIELD_SIZE,FIELD_SIZE];

    private GameObject[,] _fieldObjects = new GameObject[FIELD_SIZE,FIELD_SIZE];
    private int[,] numberField = new int[FIELD_SIZE,FIELD_SIZE];
    private GameObject[,] textField = new GameObject[FIELD_SIZE,FIELD_SIZE];
     private GameObject playerObject = null;
    private Block playerBlock = null;
    private GameObject playerText = null;

    private Vector3 touchStartPos;
    private Vector3 touchEndPos;
    private bool isFlick;//フリックかどうか
    private bool isClick;//クリックかどうか
    private int direction;//フリックの方向管理


    private FinishBoard _finishBoard;
    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < FIELD_SIZE; i++)
        {
            for (int j = 0; j < FIELD_SIZE; j++)
            {
        GameObject newObject = GameObject.Instantiate<GameObject>(_block);
        GameObject newText = newObject.transform.GetChild(0).GetChild(0).gameObject;
        Block newBlock = newObject.GetComponent<Block>();
        newObject.GetComponent<Renderer>().material.color = blockColor;
        newObject.transform.localPosition = new Vector3(i,0.0f,j);
        _fieldObjects[i,j] = newObject;
        _fieldBlocks[i,j] = newBlock;
        numberField[i,j] = 0;
        textField[i,j] = newText;
            }
        }
         numberField[playerX,playerY] = playerPower;
        playerObject = GameObject.Instantiate<GameObject>(_block);
        playerText = playerObject.transform.GetChild(0).GetChild(0).gameObject;
        playerBlock = playerObject.GetComponent<Block>();
        playerObject.transform.localPosition = new Vector3(playerX*1.0f,0.01f,playerY*1.0f);
        playerBlock.GetComponent<Renderer>().material.color = playerColor;
        playerText.GetComponent<Text>().text = playerPower.ToString();
        GameObject finishBoard = GameObject.Find("FinishBoard");
        _finishBoard = finishBoard.GetComponent<FinishBoard>();
        _finishBoard.StartGame();
        
    }

    // Update is called once per frame
    void Update()
    {   
        //Flick();
        if (!isDevelop)
        {
            if (isHavingAnimation)
            {
                MovePlayerAnimation();
            }
            else
            {
                if (GetKeyEx(KeyCode.UpArrow) && CanMove(0,1))
                {
                    UpdateField(0,1);
                    
                }
                
                if (GetKeyEx(KeyCode.DownArrow) && CanMove(0,-1))
                {
                    UpdateField(0,-1);
                    
                }
                

                if (GetKeyEx(KeyCode.LeftArrow) && CanMove(-1,0))
                {
                    UpdateField(-1,0);

                }
                

                if (GetKeyEx(KeyCode.RightArrow) && CanMove(1,0))
                {
                    UpdateField(1,0);
                }
                
            }

        }
        else if (isDevelop)
        {



        if(Input.GetKeyDown (KeyCode.Mouse0))
        {
            isFlick = true;
            touchStartPos = new Vector3(Input.mousePosition.x ,
                        Input.mousePosition.y ,
                        Input.mousePosition.z);
            Invoke ("FlickOff" , 0.2f);
        }
        if(Input.GetKey (KeyCode.Mouse0))
        {
            touchEndPos = new Vector3(Input.mousePosition.x ,
                        Input.mousePosition.y ,
                        Input.mousePosition.z);
            if(touchStartPos != touchEndPos )
            {
                ClickOff ();
            }
        }
        if(Input.GetKeyUp (KeyCode.Mouse0))
        {
            touchEndPos = new Vector3(Input.mousePosition.x ,
                        Input.mousePosition.y ,
                        Input.mousePosition.z);
            Debug.Log (touchEndPos);
            if(IsFlick ())
            {
                Debug.Log ("Flick");
                float directionX = touchEndPos.x - touchStartPos.x;
                float directionY = touchEndPos.y - touchStartPos.y;
                Debug.Log ("DirectionX : " + directionX);
                Debug.Log ("DirectionY : " + directionY);
                if(Mathf.Abs (directionY) < Mathf.Abs (directionX))
                {
                    if(0 < directionX)
                    {
                        Debug.Log ("Flick : Right");
                        direction = 6;
                    }
                    else if (0 > directionX)
                    {
                        Debug.Log ("Flick : Left");
                        direction = 4;
                    }
                }
                else if(Mathf.Abs (directionX) < Mathf.Abs (directionY))
                {
                    if(0 < directionY)
                    {
                        Debug.Log ("Flick : Up");
                        direction = 2;
                    }
                    else if (0 > directionY)
                    {
                        Debug.Log ("Flick : Down");
                        direction = 8;
                    }
                }
                else
                {
                    Debug.Log ("Flick : Not, It's Tap");
                    FlickOff();
                }
            }
            else
            {
                Debug.Log ("Long Touch");
                direction = 5;
            }
        }

        if (isHavingAnimation)
                {
                    MovePlayerAnimation();
                }
                else
                {
                    if (direction == 2 && CanMove(0,1))
                    {
                    
                        UpdateField(0,1);
                    }
                    if (direction == 8 && CanMove(0,-1))
                    {
                        
                        UpdateField(0,-1);
                    }
                    if (direction == 4 && CanMove(-1,0))
                    {
                    
                        UpdateField(-1,0);
                    }
                    if (direction == 6 && CanMove(1,0))
                    {
                        
                        UpdateField(1,0);
                    }
                }
        }
    }
    void MovePlayerAnimation()
    {
    if (animationFrame <= fullAnimationFrame-1)
    {
    Vector3 pos = playerObject.transform.position;
    pos.x += (float)moveInfo[0]/10.0f;
    pos.z += (float)moveInfo[1]/10.0f;
    playerObject.transform.localPosition = pos;
    animationFrame++;
    }
    if (animationFrame == fullAnimationFrame)
    {
        updateColorAndNumber();
        isHavingAnimation = false;
        animationFrame = 0;
    }

    }
    void UpdateField(int x, int y)
    {
        Move(x,y);
        GrowEnemy();
        if (!isBeatEnemy)
        {
            spawnEnemy();
        }
        
        isHavingAnimation = true;
        checkFinish();
    }
    
    void Move(int x, int y)
    {
        moveInfo[0] = x;
        moveInfo[1] = y;
        numberField[playerX,playerY] = 0;
        //移動した時に瞬時に移動ますがリセットされるよう
        _fieldObjects[playerX,playerY].GetComponent<Renderer>().material.color = blockColor;
        textField[playerX,playerY].GetComponent<Text>().text = "";
        playerX += x;
        playerY += y;
        textField[playerX,playerY].GetComponent<Text>().text = "";
        if (numberField[playerX,playerY] != 0)
        {
            playerPower += numberField[playerX,playerY];//playerPower++;
            GetComponents<AudioSource>()[0].Play();
            isBeatEnemy = true;
        }
        else
        {
            GetComponents<AudioSource>()[2].Play();
            isBeatEnemy = false;
        }
        numberField[playerX,playerY] = playerPower;
    }
    void decideEnemyColor(int enemy)
    {
        if (playerPower < enemy)
        {
            enemyColor = "#FFE40D".ToColor();
        }
        else if (playerPower >= enemy*2)
        {
            enemyColor = "#ADFF00".ToColor();
        }
        // else if (playerPower > enemy*3)
        // {
        //     enemyColor = "#ADFF00".ToColor();
        // }
        // else if (playerPower > enemy*4)
        // {
        //     enemyColor = "#55E80C".ToColor();
        // }
        else
        {
            enemyColor = "#0DFF10".ToColor();
        }
    }
    void updateColorAndNumber()
    {
        for (int i = 0; i < FIELD_SIZE; i++)
        {
            for (int j = 0; j < FIELD_SIZE; j++)
            {
               if (numberField[i,j] == 0)
                {
             _fieldObjects[i,j].GetComponent<Renderer>().material.color = blockColor;
             textField[i,j].GetComponent<Text>().text = "";
                }
                else
                {
            if (!(i == playerX && j == playerY))
            {
             textField[i,j].GetComponent<Text>().text = numberField[i,j].ToString();
            }
            decideEnemyColor(numberField[i,j]);
             _fieldObjects[i,j].GetComponent<Renderer>().material.color = enemyColor;
                }
            }
        }
       
        //プレイヤー移動後に升目の色を青にするため
        _fieldObjects[playerX,playerY].GetComponent<Renderer>().material.color = blockColor;
        //Debug.Log(playerPower);
        // textField[playerX,playerY].GetComponent<Text>().text = playerPower.ToString();
        playerText.GetComponent<Text>().text = playerPower.ToString();


    }
    void GrowEnemy()
    {
        for (int i = 0; i < FIELD_SIZE; i++)
        {
            for (int j = 0; j < FIELD_SIZE; j++)
            {
               if (numberField[i,j] != 0)
               {
                   numberField[i,j]++;
               }
            }
        }
    }
    void spawnEnemy()
    {
        List<int> noEnemyList = new List<int>();
        for (int i = 0; i < FIELD_SIZE; i++)
        {
            for (int j = 0; j < FIELD_SIZE; j++)
            {
                if (numberField[i,j] == 0)
                {
                    noEnemyList.Add(i * FIELD_SIZE + j);
                }
            }
        }
        if (noEnemyList.Count <= FIELD_SIZE*FIELD_SIZE-1)
        {
           
        int number = noEnemyList[Random.Range(0,noEnemyList.Count)];
        int y = number%FIELD_SIZE;
        int x = (number-y)/FIELD_SIZE;
        Debug.Log(spawnEnemyPower+"spawn");
        spawnEnemyPower = Random.Range(1,3);
        numberField[x,y] = spawnEnemyPower;
         
        }
    }
    bool CanMove(int x,int y)
    {
        if (0 <= playerX + x && playerX + x < FIELD_SIZE  && 0 <= playerY + y && playerY + y < FIELD_SIZE)
        {         

            if (numberField[playerX + x,playerY + y] != 0)//playerPower > numberField[playerX + x,playerY + y])
            {
                if (playerPower%numberField[playerX + x,playerY + y] == 0 && numberField[playerX + x,playerY + y] != 1)
                {
                  return true;
                }
                else
                {

                //GetComponents<AudioSource>()[1].Play();
                return false;
                }
            }
            else
            {
            return true;
            }
        }
        else
        {
            //GetComponents<AudioSource>()[1].Play();
            return false;
        }


    }
    void checkFinish()
    {
        if (!CanMove(0,1) && !CanMove(0,-1) && !CanMove(1,0) && !CanMove(-1,0))
        {
            _finishBoard.FinishGame();

        }
    }
    public void createNewGame()
    {
        for (int i = 0; i < FIELD_SIZE; i++)
        {
            for (int j = 0; j < FIELD_SIZE; j++)
            {
                
            numberField[i,j] = 0;
            _fieldObjects[i,j].GetComponent<Renderer>().material.color = blockColor;
            textField[i,j].GetComponent<Text>().text = "";
            }
        }
        playerPower = 2;
        playerX = defaultPlayerX;
        playerY = defaultPlayerY;
        numberField[playerX,playerY] = playerPower;
        playerObject.transform.localPosition = new Vector3(playerX*1.0f,0.01f,playerY*1.0f);
        playerBlock.GetComponent<Renderer>().material.color = playerColor;
        playerText.GetComponent<Text>().text = playerPower.ToString();
        _finishBoard.StartGame();
    }
     private Dictionary<KeyCode, int> _keyInputTimer = new Dictionary<KeyCode, int>();
     private bool GetKeyEx(KeyCode keyCode)
    {
        if (!_keyInputTimer.ContainsKey(keyCode))
        {
          _keyInputTimer.Add(keyCode, -1);  
        }
        if (Input.GetKey(keyCode))
        {
            _keyInputTimer[keyCode]++;
        }
        else
        {
            _keyInputTimer[keyCode] = -1;
        }
        return (_keyInputTimer[keyCode] == 0 );
    }

    public void FlickOff()
    {
        direction = 5;
        isFlick = false;
    }

    public bool IsFlick()
    {
        return isFlick;
    }


    public void ClickOn()
    {
        isClick = true;
        Invoke ("ClickOff" , 0.2f);
    }

    public bool IsClick()
    {
        return isClick;
    }

    public void ClickOff()
    {
        isClick = false;
    }
    
}
