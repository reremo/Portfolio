using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HighScore : MonoBehaviour
{
    private int highScore; //ハイスコア用変数
    private string key = "HIGH SCORE"; //ハイスコアの保存先キー

    // Start is called before the first frame update
    void Start()
    {
        highScore = PlayerPrefs.GetInt(key, 0);
       
    }

    // Update is called once per frame
    void Update()
    {
        //ハイスコアより現在スコアが高い時
        if (GameSystem.playerPower > highScore) {

                highScore = GameSystem.playerPower;
                //ハイスコア更新

                PlayerPrefs.SetInt(key, highScore);
                //ハイスコアを保存
        }
        this.GetComponent<Text>().text = PlayerPrefs.GetInt("HIGH SCORE").ToString();

    }
}
