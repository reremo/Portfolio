using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Score : MonoBehaviour
{
    int _score;
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        _score = GameSystem.playerPower;
        this.GetComponent<Text>().text = _score.ToString();
    }
}
