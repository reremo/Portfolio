using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinishBoard : MonoBehaviour
{
    bool isFinish = false;
    int time = 0;
    public void FinishGame()
    {
        isFinish = true;   
    }
    public void StartGame()
    {
        this.GetComponent<CanvasGroup>().alpha = 0.0f;
        isFinish = false;
        time = 0;
    }
    void Update()
    {
        if (isFinish)
        {
             time += 1;
             Debug.Log(time);
             if (time >= 60)
             {
            float al = this.GetComponent<CanvasGroup>().alpha;
            if (al < 0.9f)
            {
            al += 0.1f;
            this.GetComponent<CanvasGroup>().alpha = al;
            }
            else
            {
                isFinish = false;
            }
            }
        }

    }

}
